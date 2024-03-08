-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_666 is
end project_tb_666;

architecture project_tb_arch_666 of project_tb_666 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 405;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (250,0,206,0,176,0,204,0,253,0,30,0,190,0,112,0,139,0,89,0,74,0,29,0,74,0,255,0,222,0,95,0,81,0,0,0,0,0,97,0,0,0,0,0,208,0,201,0,251,0,102,0,120,0,171,0,0,0,0,0,16,0,45,0,68,0,125,0,0,0,196,0,189,0,167,0,26,0,220,0,180,0,169,0,87,0,0,0,0,0,161,0,89,0,0,0,31,0,205,0,0,0,105,0,136,0,75,0,222,0,251,0,0,0,249,0,50,0,12,0,0,0,53,0,89,0,0,0,253,0,86,0,179,0,200,0,29,0,0,0,17,0,76,0,134,0,181,0,28,0,213,0,12,0,24,0,160,0,0,0,22,0,0,0,172,0,209,0,133,0,149,0,195,0,0,0,185,0,83,0,0,0,0,0,253,0,0,0,3,0,0,0,139,0,65,0,58,0,0,0,0,0,193,0,136,0,0,0,225,0,171,0,0,0,123,0,0,0,124,0,0,0,97,0,90,0,91,0,221,0,58,0,78,0,225,0,247,0,88,0,0,0,15,0,0,0,16,0,111,0,163,0,91,0,200,0,95,0,146,0,222,0,245,0,0,0,193,0,0,0,190,0,55,0,69,0,161,0,4,0,95,0,0,0,198,0,0,0,0,0,186,0,50,0,155,0,0,0,141,0,0,0,39,0,130,0,0,0,29,0,59,0,83,0,95,0,0,0,0,0,0,0,250,0,0,0,215,0,46,0,224,0,138,0,69,0,0,0,46,0,245,0,231,0,109,0,37,0,67,0,207,0,229,0,138,0,83,0,8,0,228,0,0,0,59,0,212,0,0,0,109,0,166,0,131,0,30,0,27,0,0,0,217,0,235,0,102,0,153,0,0,0,238,0,153,0,85,0,67,0,89,0,0,0,184,0,62,0,0,0,131,0,0,0,115,0,0,0,36,0,46,0,220,0,135,0,159,0,171,0,84,0,217,0,235,0,211,0,143,0,0,0,0,0,180,0,24,0,8,0,0,0,138,0,108,0,221,0,67,0,196,0,161,0,201,0,229,0,163,0,230,0,0,0,147,0,10,0,181,0,87,0,118,0,26,0,42,0,192,0,0,0,0,0,152,0,0,0,0,0,192,0,159,0,245,0,36,0,58,0,9,0,111,0,0,0,56,0,170,0,209,0,199,0,197,0,0,0,209,0,149,0,71,0,0,0,184,0,253,0,98,0,179,0,20,0,140,0,95,0,62,0,145,0,232,0,248,0,209,0,4,0,24,0,83,0,0,0,229,0,0,0,0,0,71,0,0,0,0,0,116,0,204,0,82,0,0,0,14,0,0,0,51,0,27,0,131,0,12,0,123,0,123,0,244,0,11,0,44,0,200,0,30,0,222,0,250,0,188,0,0,0,137,0,44,0,90,0,119,0,154,0,0,0,0,0,222,0,0,0,26,0,0,0,168,0,103,0,178,0,95,0,51,0,41,0,0,0,215,0,246,0,0,0,126,0,4,0,246,0,0,0,108,0,0,0,32,0,182,0,53,0,29,0,0,0,0,0,0,0,245,0,0,0,0,0,0,0,112,0,130,0,155,0,50,0,206,0,104,0,55,0,23,0,207,0,24,0,233,0,110,0,0,0,153,0,184,0,206,0,85,0,183,0,244,0,159,0,116,0,155,0,221,0,238,0,55,0,0,0,18,0,0,0,175,0,0,0,253,0,76,0,107,0,236,0,0,0,84,0,181,0,18,0,132,0,0,0,0,0,101,0,55,0,154,0,249,0,0,0,218,0,30,0,185,0,0,0,91,0,144,0,16,0,20,0,147,0,12,0);
signal scenario_full  : scenario_type := (250,31,206,31,176,31,204,31,253,31,30,31,190,31,112,31,139,31,89,31,74,31,29,31,74,31,255,31,222,31,95,31,81,31,81,30,81,29,97,31,97,30,97,29,208,31,201,31,251,31,102,31,120,31,171,31,171,30,171,29,16,31,45,31,68,31,125,31,125,30,196,31,189,31,167,31,26,31,220,31,180,31,169,31,87,31,87,30,87,29,161,31,89,31,89,30,31,31,205,31,205,30,105,31,136,31,75,31,222,31,251,31,251,30,249,31,50,31,12,31,12,30,53,31,89,31,89,30,253,31,86,31,179,31,200,31,29,31,29,30,17,31,76,31,134,31,181,31,28,31,213,31,12,31,24,31,160,31,160,30,22,31,22,30,172,31,209,31,133,31,149,31,195,31,195,30,185,31,83,31,83,30,83,29,253,31,253,30,3,31,3,30,139,31,65,31,58,31,58,30,58,29,193,31,136,31,136,30,225,31,171,31,171,30,123,31,123,30,124,31,124,30,97,31,90,31,91,31,221,31,58,31,78,31,225,31,247,31,88,31,88,30,15,31,15,30,16,31,111,31,163,31,91,31,200,31,95,31,146,31,222,31,245,31,245,30,193,31,193,30,190,31,55,31,69,31,161,31,4,31,95,31,95,30,198,31,198,30,198,29,186,31,50,31,155,31,155,30,141,31,141,30,39,31,130,31,130,30,29,31,59,31,83,31,95,31,95,30,95,29,95,28,250,31,250,30,215,31,46,31,224,31,138,31,69,31,69,30,46,31,245,31,231,31,109,31,37,31,67,31,207,31,229,31,138,31,83,31,8,31,228,31,228,30,59,31,212,31,212,30,109,31,166,31,131,31,30,31,27,31,27,30,217,31,235,31,102,31,153,31,153,30,238,31,153,31,85,31,67,31,89,31,89,30,184,31,62,31,62,30,131,31,131,30,115,31,115,30,36,31,46,31,220,31,135,31,159,31,171,31,84,31,217,31,235,31,211,31,143,31,143,30,143,29,180,31,24,31,8,31,8,30,138,31,108,31,221,31,67,31,196,31,161,31,201,31,229,31,163,31,230,31,230,30,147,31,10,31,181,31,87,31,118,31,26,31,42,31,192,31,192,30,192,29,152,31,152,30,152,29,192,31,159,31,245,31,36,31,58,31,9,31,111,31,111,30,56,31,170,31,209,31,199,31,197,31,197,30,209,31,149,31,71,31,71,30,184,31,253,31,98,31,179,31,20,31,140,31,95,31,62,31,145,31,232,31,248,31,209,31,4,31,24,31,83,31,83,30,229,31,229,30,229,29,71,31,71,30,71,29,116,31,204,31,82,31,82,30,14,31,14,30,51,31,27,31,131,31,12,31,123,31,123,31,244,31,11,31,44,31,200,31,30,31,222,31,250,31,188,31,188,30,137,31,44,31,90,31,119,31,154,31,154,30,154,29,222,31,222,30,26,31,26,30,168,31,103,31,178,31,95,31,51,31,41,31,41,30,215,31,246,31,246,30,126,31,4,31,246,31,246,30,108,31,108,30,32,31,182,31,53,31,29,31,29,30,29,29,29,28,245,31,245,30,245,29,245,28,112,31,130,31,155,31,50,31,206,31,104,31,55,31,23,31,207,31,24,31,233,31,110,31,110,30,153,31,184,31,206,31,85,31,183,31,244,31,159,31,116,31,155,31,221,31,238,31,55,31,55,30,18,31,18,30,175,31,175,30,253,31,76,31,107,31,236,31,236,30,84,31,181,31,18,31,132,31,132,30,132,29,101,31,55,31,154,31,249,31,249,30,218,31,30,31,185,31,185,30,91,31,144,31,16,31,20,31,147,31,12,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;

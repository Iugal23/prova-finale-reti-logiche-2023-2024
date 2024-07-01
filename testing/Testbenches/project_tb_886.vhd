-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_886 is
end project_tb_886;

architecture project_tb_arch_886 of project_tb_886 is
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

constant SCENARIO_LENGTH : integer := 351;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (136,0,25,0,111,0,115,0,112,0,147,0,233,0,0,0,0,0,0,0,196,0,0,0,23,0,145,0,0,0,155,0,242,0,0,0,173,0,94,0,22,0,252,0,0,0,0,0,0,0,14,0,209,0,31,0,0,0,58,0,16,0,102,0,32,0,0,0,32,0,35,0,175,0,67,0,50,0,129,0,189,0,211,0,9,0,212,0,68,0,173,0,47,0,0,0,235,0,56,0,133,0,0,0,250,0,164,0,230,0,195,0,11,0,0,0,3,0,237,0,206,0,73,0,244,0,236,0,213,0,252,0,120,0,112,0,0,0,135,0,83,0,59,0,0,0,105,0,0,0,22,0,166,0,121,0,113,0,107,0,120,0,0,0,206,0,174,0,67,0,144,0,197,0,0,0,0,0,243,0,0,0,190,0,127,0,0,0,0,0,22,0,124,0,0,0,220,0,26,0,251,0,17,0,246,0,186,0,192,0,208,0,80,0,172,0,28,0,247,0,16,0,103,0,230,0,149,0,235,0,7,0,44,0,0,0,0,0,217,0,81,0,126,0,127,0,206,0,0,0,70,0,24,0,162,0,65,0,9,0,123,0,0,0,113,0,86,0,166,0,144,0,102,0,173,0,0,0,46,0,230,0,202,0,80,0,173,0,0,0,196,0,0,0,10,0,121,0,71,0,249,0,201,0,0,0,200,0,0,0,0,0,0,0,241,0,40,0,229,0,20,0,122,0,0,0,216,0,77,0,99,0,227,0,196,0,32,0,39,0,107,0,244,0,7,0,73,0,0,0,204,0,41,0,0,0,191,0,37,0,151,0,227,0,199,0,180,0,152,0,189,0,0,0,144,0,245,0,162,0,35,0,183,0,223,0,54,0,0,0,101,0,78,0,170,0,34,0,0,0,0,0,226,0,98,0,230,0,216,0,202,0,0,0,0,0,0,0,206,0,0,0,25,0,101,0,116,0,249,0,0,0,0,0,185,0,238,0,90,0,74,0,191,0,147,0,95,0,233,0,246,0,0,0,47,0,209,0,69,0,45,0,0,0,0,0,230,0,0,0,43,0,201,0,0,0,0,0,0,0,255,0,153,0,96,0,175,0,105,0,233,0,35,0,25,0,0,0,224,0,184,0,33,0,44,0,186,0,182,0,0,0,168,0,30,0,99,0,175,0,190,0,73,0,236,0,6,0,5,0,213,0,0,0,134,0,205,0,0,0,97,0,0,0,134,0,64,0,0,0,0,0,208,0,51,0,109,0,82,0,99,0,30,0,200,0,149,0,131,0,27,0,202,0,215,0,99,0,159,0,190,0,132,0,255,0,0,0,45,0,208,0,0,0,52,0,84,0,164,0,75,0,0,0,173,0,182,0,68,0,169,0,229,0,40,0,0,0,53,0,108,0,35,0,156,0,0,0,223,0,14,0,0,0,153,0,80,0,3,0,163,0,219,0,118,0,24,0,1,0,25,0,224,0,0,0,236,0,45,0,26,0,250,0,96,0,17,0,16,0,0,0,0,0,2,0,204,0,113,0,127,0,0,0,94,0,61,0,183,0,13,0,0,0,0,0,176,0,247,0,210,0);
signal scenario_full  : scenario_type := (136,31,25,31,111,31,115,31,112,31,147,31,233,31,233,30,233,29,233,28,196,31,196,30,23,31,145,31,145,30,155,31,242,31,242,30,173,31,94,31,22,31,252,31,252,30,252,29,252,28,14,31,209,31,31,31,31,30,58,31,16,31,102,31,32,31,32,30,32,31,35,31,175,31,67,31,50,31,129,31,189,31,211,31,9,31,212,31,68,31,173,31,47,31,47,30,235,31,56,31,133,31,133,30,250,31,164,31,230,31,195,31,11,31,11,30,3,31,237,31,206,31,73,31,244,31,236,31,213,31,252,31,120,31,112,31,112,30,135,31,83,31,59,31,59,30,105,31,105,30,22,31,166,31,121,31,113,31,107,31,120,31,120,30,206,31,174,31,67,31,144,31,197,31,197,30,197,29,243,31,243,30,190,31,127,31,127,30,127,29,22,31,124,31,124,30,220,31,26,31,251,31,17,31,246,31,186,31,192,31,208,31,80,31,172,31,28,31,247,31,16,31,103,31,230,31,149,31,235,31,7,31,44,31,44,30,44,29,217,31,81,31,126,31,127,31,206,31,206,30,70,31,24,31,162,31,65,31,9,31,123,31,123,30,113,31,86,31,166,31,144,31,102,31,173,31,173,30,46,31,230,31,202,31,80,31,173,31,173,30,196,31,196,30,10,31,121,31,71,31,249,31,201,31,201,30,200,31,200,30,200,29,200,28,241,31,40,31,229,31,20,31,122,31,122,30,216,31,77,31,99,31,227,31,196,31,32,31,39,31,107,31,244,31,7,31,73,31,73,30,204,31,41,31,41,30,191,31,37,31,151,31,227,31,199,31,180,31,152,31,189,31,189,30,144,31,245,31,162,31,35,31,183,31,223,31,54,31,54,30,101,31,78,31,170,31,34,31,34,30,34,29,226,31,98,31,230,31,216,31,202,31,202,30,202,29,202,28,206,31,206,30,25,31,101,31,116,31,249,31,249,30,249,29,185,31,238,31,90,31,74,31,191,31,147,31,95,31,233,31,246,31,246,30,47,31,209,31,69,31,45,31,45,30,45,29,230,31,230,30,43,31,201,31,201,30,201,29,201,28,255,31,153,31,96,31,175,31,105,31,233,31,35,31,25,31,25,30,224,31,184,31,33,31,44,31,186,31,182,31,182,30,168,31,30,31,99,31,175,31,190,31,73,31,236,31,6,31,5,31,213,31,213,30,134,31,205,31,205,30,97,31,97,30,134,31,64,31,64,30,64,29,208,31,51,31,109,31,82,31,99,31,30,31,200,31,149,31,131,31,27,31,202,31,215,31,99,31,159,31,190,31,132,31,255,31,255,30,45,31,208,31,208,30,52,31,84,31,164,31,75,31,75,30,173,31,182,31,68,31,169,31,229,31,40,31,40,30,53,31,108,31,35,31,156,31,156,30,223,31,14,31,14,30,153,31,80,31,3,31,163,31,219,31,118,31,24,31,1,31,25,31,224,31,224,30,236,31,45,31,26,31,250,31,96,31,17,31,16,31,16,30,16,29,2,31,204,31,113,31,127,31,127,30,94,31,61,31,183,31,13,31,13,30,13,29,176,31,247,31,210,31);

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

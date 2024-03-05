-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 374;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (136,0,66,0,186,0,167,0,0,0,144,0,119,0,105,0,5,0,0,0,172,0,104,0,207,0,0,0,0,0,12,0,73,0,2,0,16,0,168,0,0,0,193,0,62,0,6,0,212,0,33,0,139,0,143,0,0,0,252,0,255,0,0,0,0,0,24,0,0,0,44,0,91,0,0,0,206,0,124,0,0,0,0,0,109,0,18,0,130,0,210,0,186,0,0,0,31,0,45,0,100,0,0,0,222,0,185,0,184,0,115,0,183,0,17,0,221,0,77,0,62,0,94,0,38,0,0,0,175,0,207,0,203,0,147,0,32,0,0,0,223,0,226,0,216,0,173,0,36,0,143,0,130,0,8,0,30,0,0,0,100,0,14,0,176,0,0,0,94,0,0,0,168,0,0,0,72,0,0,0,59,0,118,0,212,0,243,0,134,0,80,0,115,0,8,0,53,0,124,0,112,0,152,0,76,0,0,0,63,0,0,0,0,0,0,0,173,0,192,0,0,0,68,0,168,0,19,0,162,0,0,0,0,0,126,0,0,0,113,0,0,0,0,0,231,0,14,0,249,0,255,0,0,0,124,0,224,0,235,0,74,0,247,0,158,0,0,0,207,0,160,0,150,0,27,0,0,0,140,0,26,0,0,0,227,0,139,0,64,0,182,0,0,0,82,0,104,0,249,0,237,0,0,0,215,0,123,0,15,0,12,0,153,0,220,0,208,0,0,0,94,0,34,0,228,0,0,0,227,0,18,0,61,0,240,0,0,0,177,0,239,0,127,0,107,0,0,0,0,0,203,0,32,0,111,0,226,0,33,0,180,0,150,0,236,0,33,0,26,0,0,0,0,0,84,0,190,0,0,0,152,0,179,0,150,0,230,0,54,0,47,0,25,0,111,0,67,0,8,0,252,0,56,0,39,0,0,0,206,0,163,0,59,0,33,0,6,0,223,0,122,0,169,0,121,0,235,0,157,0,57,0,41,0,134,0,181,0,251,0,61,0,60,0,207,0,18,0,172,0,136,0,13,0,73,0,117,0,0,0,0,0,234,0,12,0,253,0,151,0,184,0,102,0,140,0,88,0,25,0,190,0,172,0,183,0,82,0,14,0,74,0,17,0,0,0,35,0,249,0,135,0,14,0,66,0,64,0,211,0,0,0,171,0,0,0,58,0,0,0,75,0,9,0,155,0,34,0,231,0,0,0,169,0,77,0,103,0,137,0,56,0,107,0,166,0,215,0,107,0,159,0,142,0,195,0,19,0,5,0,127,0,14,0,120,0,46,0,2,0,176,0,238,0,0,0,0,0,0,0,241,0,0,0,91,0,179,0,197,0,246,0,228,0,0,0,0,0,10,0,0,0,91,0,0,0,130,0,250,0,218,0,155,0,0,0,241,0,229,0,101,0,75,0,109,0,66,0,44,0,122,0,0,0,176,0,208,0,0,0,113,0,37,0,8,0,204,0,0,0,47,0,27,0,170,0,192,0,254,0,164,0,177,0,106,0,118,0,0,0,0,0,17,0,223,0,251,0,0,0,155,0,32,0,161,0,0,0,95,0,20,0,250,0,221,0,104,0,88,0,88,0,54,0,0,0,0,0,86,0,0,0,251,0,169,0,15,0,103,0,0,0,0,0,213,0,89,0,0,0,0,0,252,0,0,0,63,0,0,0,80,0,63,0,0,0,0,0);
signal scenario_full  : scenario_type := (136,31,66,31,186,31,167,31,167,30,144,31,119,31,105,31,5,31,5,30,172,31,104,31,207,31,207,30,207,29,12,31,73,31,2,31,16,31,168,31,168,30,193,31,62,31,6,31,212,31,33,31,139,31,143,31,143,30,252,31,255,31,255,30,255,29,24,31,24,30,44,31,91,31,91,30,206,31,124,31,124,30,124,29,109,31,18,31,130,31,210,31,186,31,186,30,31,31,45,31,100,31,100,30,222,31,185,31,184,31,115,31,183,31,17,31,221,31,77,31,62,31,94,31,38,31,38,30,175,31,207,31,203,31,147,31,32,31,32,30,223,31,226,31,216,31,173,31,36,31,143,31,130,31,8,31,30,31,30,30,100,31,14,31,176,31,176,30,94,31,94,30,168,31,168,30,72,31,72,30,59,31,118,31,212,31,243,31,134,31,80,31,115,31,8,31,53,31,124,31,112,31,152,31,76,31,76,30,63,31,63,30,63,29,63,28,173,31,192,31,192,30,68,31,168,31,19,31,162,31,162,30,162,29,126,31,126,30,113,31,113,30,113,29,231,31,14,31,249,31,255,31,255,30,124,31,224,31,235,31,74,31,247,31,158,31,158,30,207,31,160,31,150,31,27,31,27,30,140,31,26,31,26,30,227,31,139,31,64,31,182,31,182,30,82,31,104,31,249,31,237,31,237,30,215,31,123,31,15,31,12,31,153,31,220,31,208,31,208,30,94,31,34,31,228,31,228,30,227,31,18,31,61,31,240,31,240,30,177,31,239,31,127,31,107,31,107,30,107,29,203,31,32,31,111,31,226,31,33,31,180,31,150,31,236,31,33,31,26,31,26,30,26,29,84,31,190,31,190,30,152,31,179,31,150,31,230,31,54,31,47,31,25,31,111,31,67,31,8,31,252,31,56,31,39,31,39,30,206,31,163,31,59,31,33,31,6,31,223,31,122,31,169,31,121,31,235,31,157,31,57,31,41,31,134,31,181,31,251,31,61,31,60,31,207,31,18,31,172,31,136,31,13,31,73,31,117,31,117,30,117,29,234,31,12,31,253,31,151,31,184,31,102,31,140,31,88,31,25,31,190,31,172,31,183,31,82,31,14,31,74,31,17,31,17,30,35,31,249,31,135,31,14,31,66,31,64,31,211,31,211,30,171,31,171,30,58,31,58,30,75,31,9,31,155,31,34,31,231,31,231,30,169,31,77,31,103,31,137,31,56,31,107,31,166,31,215,31,107,31,159,31,142,31,195,31,19,31,5,31,127,31,14,31,120,31,46,31,2,31,176,31,238,31,238,30,238,29,238,28,241,31,241,30,91,31,179,31,197,31,246,31,228,31,228,30,228,29,10,31,10,30,91,31,91,30,130,31,250,31,218,31,155,31,155,30,241,31,229,31,101,31,75,31,109,31,66,31,44,31,122,31,122,30,176,31,208,31,208,30,113,31,37,31,8,31,204,31,204,30,47,31,27,31,170,31,192,31,254,31,164,31,177,31,106,31,118,31,118,30,118,29,17,31,223,31,251,31,251,30,155,31,32,31,161,31,161,30,95,31,20,31,250,31,221,31,104,31,88,31,88,31,54,31,54,30,54,29,86,31,86,30,251,31,169,31,15,31,103,31,103,30,103,29,213,31,89,31,89,30,89,29,252,31,252,30,63,31,63,30,80,31,63,31,63,30,63,29);

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

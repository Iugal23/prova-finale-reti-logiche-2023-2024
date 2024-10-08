-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_182 is
end project_tb_182;

architecture project_tb_arch_182 of project_tb_182 is
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

constant SCENARIO_LENGTH : integer := 396;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (9,0,123,0,221,0,225,0,8,0,7,0,212,0,0,0,0,0,157,0,201,0,149,0,47,0,246,0,66,0,124,0,252,0,190,0,158,0,87,0,179,0,0,0,177,0,101,0,0,0,17,0,248,0,177,0,166,0,0,0,116,0,0,0,120,0,72,0,0,0,0,0,69,0,211,0,21,0,53,0,163,0,0,0,191,0,190,0,104,0,19,0,12,0,212,0,197,0,24,0,233,0,113,0,244,0,210,0,210,0,197,0,243,0,190,0,201,0,232,0,86,0,246,0,125,0,231,0,0,0,102,0,213,0,190,0,0,0,26,0,90,0,0,0,205,0,61,0,0,0,135,0,7,0,232,0,52,0,56,0,30,0,213,0,8,0,154,0,239,0,218,0,221,0,94,0,241,0,0,0,247,0,223,0,61,0,0,0,57,0,214,0,176,0,132,0,9,0,226,0,16,0,175,0,101,0,0,0,133,0,149,0,253,0,59,0,133,0,59,0,19,0,236,0,49,0,178,0,157,0,0,0,171,0,242,0,0,0,0,0,61,0,125,0,206,0,128,0,12,0,63,0,0,0,246,0,129,0,200,0,0,0,0,0,0,0,10,0,17,0,52,0,0,0,155,0,0,0,208,0,193,0,121,0,222,0,195,0,81,0,223,0,0,0,15,0,0,0,0,0,37,0,45,0,130,0,47,0,0,0,255,0,242,0,56,0,116,0,0,0,230,0,237,0,216,0,21,0,38,0,63,0,3,0,110,0,200,0,187,0,156,0,131,0,205,0,46,0,0,0,0,0,244,0,74,0,242,0,203,0,165,0,156,0,210,0,0,0,133,0,66,0,2,0,110,0,152,0,117,0,212,0,0,0,128,0,108,0,91,0,0,0,208,0,83,0,105,0,184,0,234,0,0,0,226,0,91,0,152,0,83,0,32,0,79,0,75,0,58,0,178,0,149,0,31,0,93,0,223,0,0,0,162,0,117,0,14,0,245,0,235,0,1,0,76,0,122,0,235,0,145,0,104,0,162,0,216,0,225,0,68,0,254,0,248,0,178,0,104,0,19,0,93,0,150,0,47,0,79,0,233,0,101,0,0,0,211,0,107,0,58,0,106,0,29,0,50,0,8,0,249,0,0,0,249,0,87,0,128,0,250,0,54,0,0,0,70,0,180,0,223,0,249,0,159,0,19,0,44,0,136,0,59,0,223,0,177,0,48,0,244,0,120,0,91,0,117,0,0,0,0,0,0,0,96,0,131,0,122,0,135,0,128,0,4,0,45,0,56,0,251,0,132,0,253,0,107,0,173,0,184,0,110,0,110,0,56,0,0,0,224,0,177,0,64,0,177,0,201,0,244,0,180,0,144,0,0,0,114,0,48,0,200,0,218,0,0,0,11,0,0,0,230,0,143,0,225,0,86,0,21,0,247,0,72,0,132,0,0,0,0,0,64,0,0,0,218,0,217,0,5,0,143,0,58,0,119,0,40,0,0,0,67,0,200,0,0,0,105,0,185,0,165,0,121,0,111,0,0,0,166,0,0,0,0,0,0,0,206,0,201,0,8,0,111,0,46,0,41,0,0,0,148,0,202,0,37,0,233,0,0,0,150,0,76,0,0,0,0,0,172,0,226,0,242,0,178,0,221,0,243,0,26,0,1,0,248,0,69,0,50,0,39,0,181,0,245,0,97,0,57,0,226,0,0,0,245,0,0,0,0,0,171,0,22,0,164,0,57,0,33,0,219,0,28,0,130,0,127,0,0,0,173,0,49,0,0,0,254,0,0,0);
signal scenario_full  : scenario_type := (9,31,123,31,221,31,225,31,8,31,7,31,212,31,212,30,212,29,157,31,201,31,149,31,47,31,246,31,66,31,124,31,252,31,190,31,158,31,87,31,179,31,179,30,177,31,101,31,101,30,17,31,248,31,177,31,166,31,166,30,116,31,116,30,120,31,72,31,72,30,72,29,69,31,211,31,21,31,53,31,163,31,163,30,191,31,190,31,104,31,19,31,12,31,212,31,197,31,24,31,233,31,113,31,244,31,210,31,210,31,197,31,243,31,190,31,201,31,232,31,86,31,246,31,125,31,231,31,231,30,102,31,213,31,190,31,190,30,26,31,90,31,90,30,205,31,61,31,61,30,135,31,7,31,232,31,52,31,56,31,30,31,213,31,8,31,154,31,239,31,218,31,221,31,94,31,241,31,241,30,247,31,223,31,61,31,61,30,57,31,214,31,176,31,132,31,9,31,226,31,16,31,175,31,101,31,101,30,133,31,149,31,253,31,59,31,133,31,59,31,19,31,236,31,49,31,178,31,157,31,157,30,171,31,242,31,242,30,242,29,61,31,125,31,206,31,128,31,12,31,63,31,63,30,246,31,129,31,200,31,200,30,200,29,200,28,10,31,17,31,52,31,52,30,155,31,155,30,208,31,193,31,121,31,222,31,195,31,81,31,223,31,223,30,15,31,15,30,15,29,37,31,45,31,130,31,47,31,47,30,255,31,242,31,56,31,116,31,116,30,230,31,237,31,216,31,21,31,38,31,63,31,3,31,110,31,200,31,187,31,156,31,131,31,205,31,46,31,46,30,46,29,244,31,74,31,242,31,203,31,165,31,156,31,210,31,210,30,133,31,66,31,2,31,110,31,152,31,117,31,212,31,212,30,128,31,108,31,91,31,91,30,208,31,83,31,105,31,184,31,234,31,234,30,226,31,91,31,152,31,83,31,32,31,79,31,75,31,58,31,178,31,149,31,31,31,93,31,223,31,223,30,162,31,117,31,14,31,245,31,235,31,1,31,76,31,122,31,235,31,145,31,104,31,162,31,216,31,225,31,68,31,254,31,248,31,178,31,104,31,19,31,93,31,150,31,47,31,79,31,233,31,101,31,101,30,211,31,107,31,58,31,106,31,29,31,50,31,8,31,249,31,249,30,249,31,87,31,128,31,250,31,54,31,54,30,70,31,180,31,223,31,249,31,159,31,19,31,44,31,136,31,59,31,223,31,177,31,48,31,244,31,120,31,91,31,117,31,117,30,117,29,117,28,96,31,131,31,122,31,135,31,128,31,4,31,45,31,56,31,251,31,132,31,253,31,107,31,173,31,184,31,110,31,110,31,56,31,56,30,224,31,177,31,64,31,177,31,201,31,244,31,180,31,144,31,144,30,114,31,48,31,200,31,218,31,218,30,11,31,11,30,230,31,143,31,225,31,86,31,21,31,247,31,72,31,132,31,132,30,132,29,64,31,64,30,218,31,217,31,5,31,143,31,58,31,119,31,40,31,40,30,67,31,200,31,200,30,105,31,185,31,165,31,121,31,111,31,111,30,166,31,166,30,166,29,166,28,206,31,201,31,8,31,111,31,46,31,41,31,41,30,148,31,202,31,37,31,233,31,233,30,150,31,76,31,76,30,76,29,172,31,226,31,242,31,178,31,221,31,243,31,26,31,1,31,248,31,69,31,50,31,39,31,181,31,245,31,97,31,57,31,226,31,226,30,245,31,245,30,245,29,171,31,22,31,164,31,57,31,33,31,219,31,28,31,130,31,127,31,127,30,173,31,49,31,49,30,254,31,254,30);

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

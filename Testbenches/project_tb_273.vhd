-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_273 is
end project_tb_273;

architecture project_tb_arch_273 of project_tb_273 is
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

constant SCENARIO_LENGTH : integer := 612;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (174,0,89,0,105,0,42,0,253,0,47,0,229,0,204,0,96,0,130,0,154,0,199,0,104,0,35,0,127,0,76,0,208,0,223,0,148,0,0,0,198,0,114,0,0,0,0,0,111,0,179,0,0,0,31,0,212,0,154,0,94,0,63,0,0,0,181,0,13,0,28,0,38,0,123,0,0,0,0,0,131,0,0,0,71,0,0,0,128,0,199,0,211,0,25,0,202,0,200,0,0,0,85,0,95,0,2,0,93,0,0,0,244,0,0,0,0,0,154,0,92,0,2,0,45,0,23,0,0,0,8,0,248,0,196,0,28,0,70,0,3,0,12,0,22,0,130,0,26,0,205,0,0,0,102,0,175,0,239,0,214,0,84,0,62,0,92,0,132,0,210,0,205,0,0,0,50,0,160,0,209,0,0,0,18,0,161,0,0,0,0,0,244,0,174,0,0,0,0,0,129,0,164,0,242,0,118,0,107,0,174,0,228,0,142,0,254,0,0,0,54,0,12,0,221,0,0,0,20,0,180,0,78,0,0,0,0,0,118,0,106,0,22,0,170,0,0,0,71,0,0,0,145,0,235,0,51,0,116,0,0,0,149,0,231,0,0,0,188,0,130,0,0,0,0,0,111,0,12,0,0,0,210,0,191,0,214,0,110,0,184,0,252,0,0,0,43,0,238,0,21,0,65,0,125,0,0,0,112,0,0,0,203,0,0,0,185,0,247,0,251,0,93,0,94,0,108,0,173,0,85,0,221,0,40,0,0,0,34,0,168,0,88,0,193,0,61,0,243,0,161,0,0,0,0,0,238,0,147,0,227,0,83,0,0,0,91,0,138,0,96,0,0,0,100,0,0,0,157,0,0,0,70,0,230,0,0,0,120,0,70,0,174,0,113,0,135,0,0,0,0,0,183,0,106,0,1,0,26,0,192,0,98,0,145,0,196,0,0,0,210,0,75,0,48,0,72,0,83,0,175,0,0,0,1,0,69,0,193,0,85,0,107,0,68,0,19,0,84,0,195,0,244,0,161,0,67,0,0,0,0,0,0,0,9,0,169,0,0,0,123,0,124,0,63,0,0,0,208,0,211,0,151,0,233,0,52,0,194,0,210,0,67,0,12,0,0,0,180,0,0,0,0,0,76,0,251,0,171,0,90,0,99,0,216,0,188,0,70,0,205,0,64,0,252,0,158,0,0,0,0,0,62,0,233,0,0,0,0,0,255,0,200,0,5,0,178,0,126,0,241,0,158,0,0,0,22,0,255,0,0,0,212,0,0,0,75,0,0,0,0,0,30,0,146,0,113,0,187,0,17,0,214,0,180,0,95,0,240,0,0,0,21,0,98,0,174,0,115,0,249,0,0,0,225,0,113,0,196,0,0,0,194,0,121,0,0,0,0,0,0,0,254,0,144,0,200,0,0,0,94,0,26,0,0,0,32,0,105,0,160,0,124,0,162,0,217,0,227,0,108,0,57,0,188,0,76,0,0,0,221,0,55,0,0,0,0,0,34,0,153,0,52,0,255,0,0,0,131,0,0,0,0,0,131,0,0,0,220,0,93,0,245,0,117,0,149,0,133,0,193,0,123,0,88,0,0,0,1,0,153,0,132,0,60,0,0,0,0,0,0,0,3,0,223,0,60,0,9,0,134,0,0,0,75,0,16,0,83,0,216,0,216,0,0,0,57,0,217,0,54,0,235,0,68,0,12,0,0,0,167,0,80,0,174,0,0,0,113,0,85,0,0,0,153,0,155,0,0,0,217,0,0,0,154,0,56,0,192,0,167,0,18,0,217,0,0,0,0,0,0,0,0,0,38,0,0,0,255,0,201,0,206,0,49,0,68,0,94,0,45,0,93,0,62,0,64,0,208,0,17,0,219,0,199,0,240,0,225,0,56,0,0,0,241,0,0,0,43,0,199,0,152,0,66,0,26,0,239,0,9,0,172,0,255,0,0,0,59,0,56,0,0,0,249,0,73,0,24,0,228,0,189,0,203,0,152,0,246,0,180,0,40,0,120,0,40,0,51,0,120,0,82,0,219,0,155,0,18,0,39,0,239,0,152,0,24,0,3,0,114,0,220,0,188,0,0,0,119,0,46,0,0,0,204,0,0,0,37,0,0,0,0,0,27,0,28,0,208,0,32,0,241,0,198,0,50,0,0,0,170,0,199,0,149,0,219,0,32,0,167,0,230,0,142,0,0,0,89,0,0,0,0,0,0,0,134,0,52,0,110,0,130,0,141,0,0,0,22,0,234,0,248,0,203,0,0,0,0,0,125,0,246,0,166,0,52,0,153,0,109,0,71,0,241,0,39,0,18,0,173,0,84,0,73,0,117,0,143,0,15,0,238,0,136,0,0,0,0,0,110,0,105,0,242,0,26,0,5,0,217,0,250,0,164,0,180,0,76,0,255,0,29,0,60,0,203,0,137,0,50,0,161,0,0,0,9,0,3,0,130,0,134,0,0,0,234,0,0,0,98,0,150,0,116,0,105,0,198,0,0,0,234,0,0,0,0,0,204,0,0,0,75,0,39,0,161,0,0,0,74,0,0,0,179,0,27,0,203,0,202,0,124,0,0,0,0,0,191,0,55,0,72,0,126,0,49,0,2,0,151,0,0,0,0,0,22,0,249,0,244,0,76,0,155,0,147,0,207,0,113,0,87,0,232,0,197,0,255,0,109,0,81,0,113,0,0,0,42,0,37,0,205,0,152,0,85,0,175,0,110,0,176,0,46,0,33,0,38,0,111,0,187,0);
signal scenario_full  : scenario_type := (174,31,89,31,105,31,42,31,253,31,47,31,229,31,204,31,96,31,130,31,154,31,199,31,104,31,35,31,127,31,76,31,208,31,223,31,148,31,148,30,198,31,114,31,114,30,114,29,111,31,179,31,179,30,31,31,212,31,154,31,94,31,63,31,63,30,181,31,13,31,28,31,38,31,123,31,123,30,123,29,131,31,131,30,71,31,71,30,128,31,199,31,211,31,25,31,202,31,200,31,200,30,85,31,95,31,2,31,93,31,93,30,244,31,244,30,244,29,154,31,92,31,2,31,45,31,23,31,23,30,8,31,248,31,196,31,28,31,70,31,3,31,12,31,22,31,130,31,26,31,205,31,205,30,102,31,175,31,239,31,214,31,84,31,62,31,92,31,132,31,210,31,205,31,205,30,50,31,160,31,209,31,209,30,18,31,161,31,161,30,161,29,244,31,174,31,174,30,174,29,129,31,164,31,242,31,118,31,107,31,174,31,228,31,142,31,254,31,254,30,54,31,12,31,221,31,221,30,20,31,180,31,78,31,78,30,78,29,118,31,106,31,22,31,170,31,170,30,71,31,71,30,145,31,235,31,51,31,116,31,116,30,149,31,231,31,231,30,188,31,130,31,130,30,130,29,111,31,12,31,12,30,210,31,191,31,214,31,110,31,184,31,252,31,252,30,43,31,238,31,21,31,65,31,125,31,125,30,112,31,112,30,203,31,203,30,185,31,247,31,251,31,93,31,94,31,108,31,173,31,85,31,221,31,40,31,40,30,34,31,168,31,88,31,193,31,61,31,243,31,161,31,161,30,161,29,238,31,147,31,227,31,83,31,83,30,91,31,138,31,96,31,96,30,100,31,100,30,157,31,157,30,70,31,230,31,230,30,120,31,70,31,174,31,113,31,135,31,135,30,135,29,183,31,106,31,1,31,26,31,192,31,98,31,145,31,196,31,196,30,210,31,75,31,48,31,72,31,83,31,175,31,175,30,1,31,69,31,193,31,85,31,107,31,68,31,19,31,84,31,195,31,244,31,161,31,67,31,67,30,67,29,67,28,9,31,169,31,169,30,123,31,124,31,63,31,63,30,208,31,211,31,151,31,233,31,52,31,194,31,210,31,67,31,12,31,12,30,180,31,180,30,180,29,76,31,251,31,171,31,90,31,99,31,216,31,188,31,70,31,205,31,64,31,252,31,158,31,158,30,158,29,62,31,233,31,233,30,233,29,255,31,200,31,5,31,178,31,126,31,241,31,158,31,158,30,22,31,255,31,255,30,212,31,212,30,75,31,75,30,75,29,30,31,146,31,113,31,187,31,17,31,214,31,180,31,95,31,240,31,240,30,21,31,98,31,174,31,115,31,249,31,249,30,225,31,113,31,196,31,196,30,194,31,121,31,121,30,121,29,121,28,254,31,144,31,200,31,200,30,94,31,26,31,26,30,32,31,105,31,160,31,124,31,162,31,217,31,227,31,108,31,57,31,188,31,76,31,76,30,221,31,55,31,55,30,55,29,34,31,153,31,52,31,255,31,255,30,131,31,131,30,131,29,131,31,131,30,220,31,93,31,245,31,117,31,149,31,133,31,193,31,123,31,88,31,88,30,1,31,153,31,132,31,60,31,60,30,60,29,60,28,3,31,223,31,60,31,9,31,134,31,134,30,75,31,16,31,83,31,216,31,216,31,216,30,57,31,217,31,54,31,235,31,68,31,12,31,12,30,167,31,80,31,174,31,174,30,113,31,85,31,85,30,153,31,155,31,155,30,217,31,217,30,154,31,56,31,192,31,167,31,18,31,217,31,217,30,217,29,217,28,217,27,38,31,38,30,255,31,201,31,206,31,49,31,68,31,94,31,45,31,93,31,62,31,64,31,208,31,17,31,219,31,199,31,240,31,225,31,56,31,56,30,241,31,241,30,43,31,199,31,152,31,66,31,26,31,239,31,9,31,172,31,255,31,255,30,59,31,56,31,56,30,249,31,73,31,24,31,228,31,189,31,203,31,152,31,246,31,180,31,40,31,120,31,40,31,51,31,120,31,82,31,219,31,155,31,18,31,39,31,239,31,152,31,24,31,3,31,114,31,220,31,188,31,188,30,119,31,46,31,46,30,204,31,204,30,37,31,37,30,37,29,27,31,28,31,208,31,32,31,241,31,198,31,50,31,50,30,170,31,199,31,149,31,219,31,32,31,167,31,230,31,142,31,142,30,89,31,89,30,89,29,89,28,134,31,52,31,110,31,130,31,141,31,141,30,22,31,234,31,248,31,203,31,203,30,203,29,125,31,246,31,166,31,52,31,153,31,109,31,71,31,241,31,39,31,18,31,173,31,84,31,73,31,117,31,143,31,15,31,238,31,136,31,136,30,136,29,110,31,105,31,242,31,26,31,5,31,217,31,250,31,164,31,180,31,76,31,255,31,29,31,60,31,203,31,137,31,50,31,161,31,161,30,9,31,3,31,130,31,134,31,134,30,234,31,234,30,98,31,150,31,116,31,105,31,198,31,198,30,234,31,234,30,234,29,204,31,204,30,75,31,39,31,161,31,161,30,74,31,74,30,179,31,27,31,203,31,202,31,124,31,124,30,124,29,191,31,55,31,72,31,126,31,49,31,2,31,151,31,151,30,151,29,22,31,249,31,244,31,76,31,155,31,147,31,207,31,113,31,87,31,232,31,197,31,255,31,109,31,81,31,113,31,113,30,42,31,37,31,205,31,152,31,85,31,175,31,110,31,176,31,46,31,33,31,38,31,111,31,187,31);

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

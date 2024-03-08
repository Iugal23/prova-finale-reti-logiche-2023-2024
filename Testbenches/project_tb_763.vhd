-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_763 is
end project_tb_763;

architecture project_tb_arch_763 of project_tb_763 is
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

constant SCENARIO_LENGTH : integer := 482;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,140,0,112,0,195,0,208,0,120,0,103,0,0,0,188,0,126,0,99,0,165,0,113,0,0,0,127,0,0,0,163,0,143,0,0,0,252,0,107,0,180,0,0,0,106,0,121,0,205,0,211,0,0,0,149,0,249,0,19,0,199,0,93,0,17,0,101,0,124,0,198,0,0,0,3,0,8,0,62,0,15,0,73,0,6,0,19,0,0,0,29,0,215,0,0,0,0,0,188,0,195,0,136,0,185,0,78,0,0,0,0,0,78,0,0,0,19,0,138,0,0,0,203,0,161,0,250,0,154,0,106,0,0,0,13,0,41,0,30,0,81,0,0,0,6,0,59,0,95,0,0,0,155,0,17,0,0,0,168,0,0,0,149,0,0,0,27,0,190,0,244,0,0,0,45,0,140,0,186,0,0,0,0,0,180,0,0,0,197,0,95,0,13,0,185,0,46,0,11,0,39,0,241,0,50,0,79,0,70,0,104,0,189,0,48,0,0,0,207,0,25,0,161,0,80,0,0,0,155,0,80,0,30,0,69,0,0,0,153,0,19,0,169,0,130,0,0,0,7,0,0,0,145,0,0,0,212,0,0,0,153,0,166,0,92,0,154,0,173,0,61,0,0,0,123,0,112,0,0,0,71,0,105,0,0,0,0,0,255,0,69,0,146,0,80,0,144,0,171,0,226,0,115,0,73,0,11,0,0,0,0,0,0,0,192,0,224,0,7,0,126,0,20,0,178,0,199,0,0,0,207,0,155,0,0,0,198,0,165,0,2,0,0,0,122,0,188,0,66,0,74,0,249,0,142,0,2,0,196,0,39,0,0,0,0,0,59,0,214,0,0,0,154,0,91,0,116,0,214,0,32,0,59,0,62,0,0,0,28,0,6,0,188,0,125,0,182,0,123,0,114,0,0,0,239,0,8,0,107,0,24,0,32,0,57,0,225,0,31,0,127,0,208,0,9,0,45,0,252,0,9,0,53,0,123,0,0,0,30,0,175,0,17,0,140,0,178,0,36,0,85,0,115,0,141,0,0,0,194,0,225,0,154,0,249,0,224,0,23,0,0,0,89,0,193,0,154,0,96,0,37,0,20,0,31,0,245,0,120,0,122,0,33,0,176,0,234,0,186,0,0,0,112,0,158,0,231,0,249,0,24,0,128,0,44,0,34,0,113,0,194,0,3,0,0,0,98,0,180,0,0,0,99,0,225,0,218,0,0,0,0,0,165,0,124,0,13,0,189,0,169,0,108,0,0,0,0,0,0,0,251,0,249,0,0,0,239,0,197,0,204,0,38,0,0,0,74,0,64,0,179,0,138,0,236,0,221,0,75,0,0,0,30,0,232,0,0,0,213,0,226,0,166,0,221,0,244,0,0,0,164,0,0,0,215,0,95,0,234,0,106,0,85,0,0,0,203,0,0,0,117,0,147,0,205,0,0,0,0,0,182,0,146,0,14,0,123,0,51,0,115,0,138,0,201,0,168,0,118,0,81,0,227,0,222,0,184,0,210,0,70,0,0,0,216,0,0,0,0,0,185,0,251,0,0,0,254,0,0,0,171,0,62,0,0,0,75,0,30,0,0,0,0,0,178,0,23,0,142,0,45,0,254,0,204,0,0,0,118,0,63,0,160,0,0,0,138,0,0,0,191,0,94,0,0,0,225,0,76,0,94,0,114,0,155,0,73,0,156,0,115,0,0,0,229,0,214,0,31,0,175,0,0,0,120,0,73,0,0,0,90,0,149,0,94,0,200,0,205,0,233,0,0,0,90,0,108,0,105,0,0,0,0,0,53,0,198,0,0,0,70,0,0,0,169,0,236,0,20,0,143,0,253,0,157,0,67,0,228,0,55,0,208,0,9,0,52,0,40,0,98,0,0,0,0,0,0,0,159,0,76,0,24,0,0,0,254,0,0,0,20,0,154,0,124,0,0,0,84,0,132,0,0,0,181,0,160,0,98,0,107,0,0,0,79,0,54,0,167,0,0,0,10,0,146,0,71,0,111,0,125,0,0,0,157,0,104,0,190,0,0,0,163,0,229,0,33,0,67,0,135,0,52,0,0,0,0,0,0,0,108,0,68,0,1,0,109,0,100,0,69,0,0,0,48,0,157,0,154,0,247,0,4,0,10,0,0,0,121,0,232,0,0,0,164,0,120,0,129,0,132,0);
signal scenario_full  : scenario_type := (0,0,140,31,112,31,195,31,208,31,120,31,103,31,103,30,188,31,126,31,99,31,165,31,113,31,113,30,127,31,127,30,163,31,143,31,143,30,252,31,107,31,180,31,180,30,106,31,121,31,205,31,211,31,211,30,149,31,249,31,19,31,199,31,93,31,17,31,101,31,124,31,198,31,198,30,3,31,8,31,62,31,15,31,73,31,6,31,19,31,19,30,29,31,215,31,215,30,215,29,188,31,195,31,136,31,185,31,78,31,78,30,78,29,78,31,78,30,19,31,138,31,138,30,203,31,161,31,250,31,154,31,106,31,106,30,13,31,41,31,30,31,81,31,81,30,6,31,59,31,95,31,95,30,155,31,17,31,17,30,168,31,168,30,149,31,149,30,27,31,190,31,244,31,244,30,45,31,140,31,186,31,186,30,186,29,180,31,180,30,197,31,95,31,13,31,185,31,46,31,11,31,39,31,241,31,50,31,79,31,70,31,104,31,189,31,48,31,48,30,207,31,25,31,161,31,80,31,80,30,155,31,80,31,30,31,69,31,69,30,153,31,19,31,169,31,130,31,130,30,7,31,7,30,145,31,145,30,212,31,212,30,153,31,166,31,92,31,154,31,173,31,61,31,61,30,123,31,112,31,112,30,71,31,105,31,105,30,105,29,255,31,69,31,146,31,80,31,144,31,171,31,226,31,115,31,73,31,11,31,11,30,11,29,11,28,192,31,224,31,7,31,126,31,20,31,178,31,199,31,199,30,207,31,155,31,155,30,198,31,165,31,2,31,2,30,122,31,188,31,66,31,74,31,249,31,142,31,2,31,196,31,39,31,39,30,39,29,59,31,214,31,214,30,154,31,91,31,116,31,214,31,32,31,59,31,62,31,62,30,28,31,6,31,188,31,125,31,182,31,123,31,114,31,114,30,239,31,8,31,107,31,24,31,32,31,57,31,225,31,31,31,127,31,208,31,9,31,45,31,252,31,9,31,53,31,123,31,123,30,30,31,175,31,17,31,140,31,178,31,36,31,85,31,115,31,141,31,141,30,194,31,225,31,154,31,249,31,224,31,23,31,23,30,89,31,193,31,154,31,96,31,37,31,20,31,31,31,245,31,120,31,122,31,33,31,176,31,234,31,186,31,186,30,112,31,158,31,231,31,249,31,24,31,128,31,44,31,34,31,113,31,194,31,3,31,3,30,98,31,180,31,180,30,99,31,225,31,218,31,218,30,218,29,165,31,124,31,13,31,189,31,169,31,108,31,108,30,108,29,108,28,251,31,249,31,249,30,239,31,197,31,204,31,38,31,38,30,74,31,64,31,179,31,138,31,236,31,221,31,75,31,75,30,30,31,232,31,232,30,213,31,226,31,166,31,221,31,244,31,244,30,164,31,164,30,215,31,95,31,234,31,106,31,85,31,85,30,203,31,203,30,117,31,147,31,205,31,205,30,205,29,182,31,146,31,14,31,123,31,51,31,115,31,138,31,201,31,168,31,118,31,81,31,227,31,222,31,184,31,210,31,70,31,70,30,216,31,216,30,216,29,185,31,251,31,251,30,254,31,254,30,171,31,62,31,62,30,75,31,30,31,30,30,30,29,178,31,23,31,142,31,45,31,254,31,204,31,204,30,118,31,63,31,160,31,160,30,138,31,138,30,191,31,94,31,94,30,225,31,76,31,94,31,114,31,155,31,73,31,156,31,115,31,115,30,229,31,214,31,31,31,175,31,175,30,120,31,73,31,73,30,90,31,149,31,94,31,200,31,205,31,233,31,233,30,90,31,108,31,105,31,105,30,105,29,53,31,198,31,198,30,70,31,70,30,169,31,236,31,20,31,143,31,253,31,157,31,67,31,228,31,55,31,208,31,9,31,52,31,40,31,98,31,98,30,98,29,98,28,159,31,76,31,24,31,24,30,254,31,254,30,20,31,154,31,124,31,124,30,84,31,132,31,132,30,181,31,160,31,98,31,107,31,107,30,79,31,54,31,167,31,167,30,10,31,146,31,71,31,111,31,125,31,125,30,157,31,104,31,190,31,190,30,163,31,229,31,33,31,67,31,135,31,52,31,52,30,52,29,52,28,108,31,68,31,1,31,109,31,100,31,69,31,69,30,48,31,157,31,154,31,247,31,4,31,10,31,10,30,121,31,232,31,232,30,164,31,120,31,129,31,132,31);

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

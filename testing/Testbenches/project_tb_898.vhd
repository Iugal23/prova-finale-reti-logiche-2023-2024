-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_898 is
end project_tb_898;

architecture project_tb_arch_898 of project_tb_898 is
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

constant SCENARIO_LENGTH : integer := 554;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (223,0,240,0,0,0,67,0,108,0,0,0,58,0,0,0,0,0,16,0,87,0,0,0,0,0,203,0,106,0,190,0,133,0,12,0,236,0,255,0,14,0,0,0,37,0,147,0,60,0,0,0,106,0,0,0,210,0,0,0,100,0,99,0,120,0,52,0,56,0,72,0,0,0,32,0,231,0,64,0,180,0,0,0,167,0,114,0,219,0,0,0,52,0,0,0,214,0,89,0,16,0,0,0,59,0,0,0,226,0,54,0,10,0,192,0,60,0,88,0,120,0,20,0,0,0,0,0,78,0,229,0,102,0,101,0,111,0,0,0,196,0,138,0,188,0,0,0,0,0,182,0,213,0,29,0,243,0,43,0,131,0,0,0,193,0,135,0,0,0,0,0,23,0,120,0,211,0,90,0,195,0,167,0,57,0,6,0,1,0,0,0,0,0,23,0,162,0,216,0,218,0,117,0,137,0,197,0,240,0,166,0,226,0,183,0,140,0,62,0,122,0,30,0,229,0,246,0,23,0,82,0,153,0,0,0,1,0,214,0,106,0,13,0,104,0,32,0,128,0,250,0,0,0,107,0,0,0,0,0,98,0,26,0,63,0,0,0,237,0,96,0,31,0,0,0,208,0,234,0,2,0,0,0,197,0,204,0,0,0,0,0,70,0,225,0,132,0,57,0,0,0,130,0,0,0,71,0,46,0,0,0,79,0,0,0,0,0,202,0,217,0,0,0,84,0,12,0,134,0,128,0,221,0,73,0,0,0,0,0,94,0,196,0,153,0,246,0,0,0,0,0,6,0,62,0,190,0,0,0,62,0,254,0,232,0,254,0,0,0,23,0,29,0,0,0,84,0,110,0,50,0,0,0,0,0,159,0,196,0,245,0,59,0,87,0,89,0,251,0,119,0,50,0,168,0,153,0,98,0,193,0,0,0,69,0,119,0,71,0,244,0,28,0,84,0,30,0,105,0,205,0,109,0,0,0,132,0,2,0,145,0,146,0,235,0,36,0,172,0,0,0,52,0,189,0,90,0,37,0,155,0,105,0,221,0,4,0,46,0,0,0,142,0,16,0,0,0,72,0,207,0,13,0,221,0,2,0,145,0,0,0,0,0,219,0,17,0,0,0,0,0,188,0,141,0,243,0,152,0,0,0,34,0,98,0,37,0,37,0,221,0,0,0,251,0,32,0,158,0,202,0,44,0,178,0,154,0,179,0,74,0,6,0,171,0,86,0,0,0,196,0,155,0,90,0,152,0,175,0,206,0,149,0,105,0,48,0,249,0,0,0,152,0,74,0,40,0,43,0,120,0,198,0,68,0,74,0,245,0,0,0,203,0,77,0,28,0,189,0,176,0,139,0,0,0,0,0,133,0,43,0,211,0,125,0,76,0,101,0,7,0,1,0,0,0,59,0,253,0,114,0,62,0,130,0,171,0,29,0,67,0,0,0,99,0,236,0,151,0,152,0,0,0,250,0,131,0,86,0,251,0,126,0,133,0,90,0,112,0,202,0,228,0,173,0,216,0,168,0,199,0,0,0,122,0,214,0,161,0,35,0,16,0,110,0,136,0,0,0,202,0,207,0,0,0,156,0,0,0,40,0,0,0,38,0,241,0,236,0,39,0,46,0,92,0,68,0,0,0,122,0,0,0,238,0,189,0,44,0,0,0,0,0,72,0,229,0,65,0,147,0,234,0,183,0,10,0,197,0,31,0,137,0,0,0,65,0,118,0,134,0,234,0,202,0,27,0,231,0,225,0,191,0,69,0,115,0,182,0,0,0,108,0,31,0,238,0,45,0,53,0,0,0,32,0,0,0,12,0,63,0,0,0,111,0,0,0,0,0,6,0,247,0,221,0,250,0,4,0,248,0,32,0,40,0,6,0,63,0,57,0,234,0,90,0,0,0,161,0,170,0,67,0,66,0,217,0,95,0,0,0,0,0,0,0,247,0,0,0,52,0,146,0,43,0,75,0,0,0,70,0,17,0,223,0,0,0,44,0,244,0,0,0,88,0,169,0,127,0,23,0,203,0,9,0,0,0,49,0,171,0,158,0,219,0,0,0,23,0,227,0,165,0,104,0,0,0,67,0,47,0,5,0,0,0,25,0,232,0,0,0,146,0,207,0,148,0,57,0,0,0,84,0,117,0,90,0,213,0,0,0,0,0,0,0,9,0,153,0,209,0,118,0,223,0,89,0,0,0,0,0,55,0,164,0,170,0,0,0,47,0,113,0,0,0,231,0,174,0,135,0,0,0,41,0,221,0,201,0,0,0,198,0,157,0,96,0,42,0,9,0,166,0,34,0,0,0,26,0,89,0,16,0,21,0,0,0,233,0,0,0,26,0,0,0,215,0,240,0,144,0,249,0,0,0,56,0,157,0,52,0,185,0,95,0,20,0,112,0,0,0,0,0,100,0,96,0,0,0,130,0,229,0,0,0,61,0,65,0,198,0,192,0,135,0,21,0,255,0,81,0,207,0,45,0,166,0);
signal scenario_full  : scenario_type := (223,31,240,31,240,30,67,31,108,31,108,30,58,31,58,30,58,29,16,31,87,31,87,30,87,29,203,31,106,31,190,31,133,31,12,31,236,31,255,31,14,31,14,30,37,31,147,31,60,31,60,30,106,31,106,30,210,31,210,30,100,31,99,31,120,31,52,31,56,31,72,31,72,30,32,31,231,31,64,31,180,31,180,30,167,31,114,31,219,31,219,30,52,31,52,30,214,31,89,31,16,31,16,30,59,31,59,30,226,31,54,31,10,31,192,31,60,31,88,31,120,31,20,31,20,30,20,29,78,31,229,31,102,31,101,31,111,31,111,30,196,31,138,31,188,31,188,30,188,29,182,31,213,31,29,31,243,31,43,31,131,31,131,30,193,31,135,31,135,30,135,29,23,31,120,31,211,31,90,31,195,31,167,31,57,31,6,31,1,31,1,30,1,29,23,31,162,31,216,31,218,31,117,31,137,31,197,31,240,31,166,31,226,31,183,31,140,31,62,31,122,31,30,31,229,31,246,31,23,31,82,31,153,31,153,30,1,31,214,31,106,31,13,31,104,31,32,31,128,31,250,31,250,30,107,31,107,30,107,29,98,31,26,31,63,31,63,30,237,31,96,31,31,31,31,30,208,31,234,31,2,31,2,30,197,31,204,31,204,30,204,29,70,31,225,31,132,31,57,31,57,30,130,31,130,30,71,31,46,31,46,30,79,31,79,30,79,29,202,31,217,31,217,30,84,31,12,31,134,31,128,31,221,31,73,31,73,30,73,29,94,31,196,31,153,31,246,31,246,30,246,29,6,31,62,31,190,31,190,30,62,31,254,31,232,31,254,31,254,30,23,31,29,31,29,30,84,31,110,31,50,31,50,30,50,29,159,31,196,31,245,31,59,31,87,31,89,31,251,31,119,31,50,31,168,31,153,31,98,31,193,31,193,30,69,31,119,31,71,31,244,31,28,31,84,31,30,31,105,31,205,31,109,31,109,30,132,31,2,31,145,31,146,31,235,31,36,31,172,31,172,30,52,31,189,31,90,31,37,31,155,31,105,31,221,31,4,31,46,31,46,30,142,31,16,31,16,30,72,31,207,31,13,31,221,31,2,31,145,31,145,30,145,29,219,31,17,31,17,30,17,29,188,31,141,31,243,31,152,31,152,30,34,31,98,31,37,31,37,31,221,31,221,30,251,31,32,31,158,31,202,31,44,31,178,31,154,31,179,31,74,31,6,31,171,31,86,31,86,30,196,31,155,31,90,31,152,31,175,31,206,31,149,31,105,31,48,31,249,31,249,30,152,31,74,31,40,31,43,31,120,31,198,31,68,31,74,31,245,31,245,30,203,31,77,31,28,31,189,31,176,31,139,31,139,30,139,29,133,31,43,31,211,31,125,31,76,31,101,31,7,31,1,31,1,30,59,31,253,31,114,31,62,31,130,31,171,31,29,31,67,31,67,30,99,31,236,31,151,31,152,31,152,30,250,31,131,31,86,31,251,31,126,31,133,31,90,31,112,31,202,31,228,31,173,31,216,31,168,31,199,31,199,30,122,31,214,31,161,31,35,31,16,31,110,31,136,31,136,30,202,31,207,31,207,30,156,31,156,30,40,31,40,30,38,31,241,31,236,31,39,31,46,31,92,31,68,31,68,30,122,31,122,30,238,31,189,31,44,31,44,30,44,29,72,31,229,31,65,31,147,31,234,31,183,31,10,31,197,31,31,31,137,31,137,30,65,31,118,31,134,31,234,31,202,31,27,31,231,31,225,31,191,31,69,31,115,31,182,31,182,30,108,31,31,31,238,31,45,31,53,31,53,30,32,31,32,30,12,31,63,31,63,30,111,31,111,30,111,29,6,31,247,31,221,31,250,31,4,31,248,31,32,31,40,31,6,31,63,31,57,31,234,31,90,31,90,30,161,31,170,31,67,31,66,31,217,31,95,31,95,30,95,29,95,28,247,31,247,30,52,31,146,31,43,31,75,31,75,30,70,31,17,31,223,31,223,30,44,31,244,31,244,30,88,31,169,31,127,31,23,31,203,31,9,31,9,30,49,31,171,31,158,31,219,31,219,30,23,31,227,31,165,31,104,31,104,30,67,31,47,31,5,31,5,30,25,31,232,31,232,30,146,31,207,31,148,31,57,31,57,30,84,31,117,31,90,31,213,31,213,30,213,29,213,28,9,31,153,31,209,31,118,31,223,31,89,31,89,30,89,29,55,31,164,31,170,31,170,30,47,31,113,31,113,30,231,31,174,31,135,31,135,30,41,31,221,31,201,31,201,30,198,31,157,31,96,31,42,31,9,31,166,31,34,31,34,30,26,31,89,31,16,31,21,31,21,30,233,31,233,30,26,31,26,30,215,31,240,31,144,31,249,31,249,30,56,31,157,31,52,31,185,31,95,31,20,31,112,31,112,30,112,29,100,31,96,31,96,30,130,31,229,31,229,30,61,31,65,31,198,31,192,31,135,31,21,31,255,31,81,31,207,31,45,31,166,31);

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

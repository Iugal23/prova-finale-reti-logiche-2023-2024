-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_488 is
end project_tb_488;

architecture project_tb_arch_488 of project_tb_488 is
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

signal scenario_input : scenario_type := (0,0,166,0,244,0,10,0,208,0,0,0,237,0,83,0,57,0,102,0,201,0,242,0,0,0,247,0,0,0,143,0,81,0,201,0,0,0,156,0,0,0,50,0,68,0,97,0,92,0,0,0,0,0,44,0,104,0,188,0,248,0,0,0,123,0,83,0,190,0,209,0,73,0,0,0,58,0,0,0,199,0,199,0,0,0,118,0,6,0,0,0,0,0,8,0,109,0,136,0,93,0,212,0,179,0,88,0,58,0,28,0,20,0,239,0,252,0,104,0,200,0,116,0,132,0,144,0,36,0,162,0,78,0,181,0,247,0,34,0,101,0,147,0,123,0,7,0,0,0,78,0,236,0,34,0,89,0,157,0,47,0,122,0,118,0,29,0,15,0,140,0,121,0,6,0,0,0,95,0,227,0,164,0,240,0,71,0,195,0,174,0,188,0,233,0,132,0,0,0,53,0,153,0,0,0,126,0,0,0,185,0,0,0,0,0,79,0,93,0,108,0,0,0,163,0,180,0,0,0,227,0,230,0,249,0,19,0,0,0,43,0,71,0,5,0,79,0,192,0,104,0,59,0,32,0,138,0,0,0,1,0,102,0,230,0,133,0,68,0,0,0,89,0,160,0,116,0,42,0,40,0,17,0,25,0,198,0,236,0,31,0,84,0,169,0,105,0,150,0,190,0,200,0,0,0,53,0,223,0,0,0,156,0,184,0,63,0,100,0,237,0,0,0,60,0,45,0,18,0,0,0,26,0,241,0,125,0,0,0,122,0,99,0,244,0,0,0,15,0,6,0,56,0,59,0,135,0,18,0,173,0,170,0,85,0,203,0,249,0,76,0,119,0,154,0,49,0,0,0,203,0,225,0,116,0,169,0,0,0,115,0,0,0,100,0,106,0,229,0,46,0,0,0,10,0,0,0,9,0,64,0,28,0,129,0,82,0,181,0,106,0,62,0,80,0,110,0,22,0,36,0,19,0,77,0,0,0,181,0,191,0,118,0,19,0,75,0,0,0,249,0,56,0,68,0,165,0,10,0,0,0,225,0,235,0,108,0,98,0,116,0,187,0,0,0,192,0,0,0,209,0,51,0,152,0,49,0,114,0,104,0,246,0,68,0,0,0,221,0,0,0,64,0,26,0,210,0,2,0,214,0,163,0,0,0,189,0,198,0,208,0,21,0,7,0,216,0,214,0,47,0,15,0,239,0,4,0,0,0,0,0,24,0,0,0,7,0,176,0,0,0,28,0,37,0,75,0,175,0,99,0,85,0,0,0,155,0,156,0,87,0,0,0,125,0,27,0,189,0,235,0,88,0,0,0,132,0,139,0,136,0,165,0,75,0,0,0,0,0,0,0,0,0,0,0,0,0,224,0,250,0,199,0,163,0,6,0,0,0,86,0,0,0,195,0,201,0,28,0,175,0,169,0,0,0,135,0,126,0,227,0,69,0,0,0,10,0,0,0,58,0,0,0,0,0,100,0,199,0,30,0,108,0,241,0,134,0,103,0,238,0,144,0,238,0,0,0,68,0,81,0,0,0,247,0,43,0,201,0,243,0,67,0,147,0,117,0,92,0,107,0,0,0,11,0,151,0,227,0,226,0,22,0,172,0,167,0,190,0,0,0,128,0,14,0,137,0,47,0,0,0,147,0,0,0,129,0,185,0,245,0,0,0,77,0,200,0,147,0,23,0,0,0,65,0,0,0,0,0,233,0,35,0,208,0,192,0,40,0,91,0,112,0,0,0,119,0,149,0,0,0,1,0,113,0,160,0,113,0,105,0,31,0,6,0,8,0,246,0,81,0,165,0,215,0,196,0,254,0,232,0,105,0,94,0,232,0,145,0,0,0,214,0,23,0,224,0,140,0,161,0,193,0,247,0,72,0,211,0,82,0,65,0,246,0,154,0,105,0,0,0,128,0,124,0,38,0,76,0,251,0,102,0,228,0,117,0,26,0,134,0,0,0,254,0,181,0,249,0,124,0,238,0,143,0,227,0,141,0,0,0,0,0,255,0,0,0,9,0,49,0,0,0,30,0,0,0,80,0,126,0,111,0,190,0,230,0,171,0,196,0,148,0,116,0,173,0,36,0,0,0,73,0,147,0,5,0,77,0,0,0,111,0,0,0,47,0,151,0,43,0,159,0,237,0,57,0,187,0,237,0,117,0,152,0,216,0,242,0,0,0,227,0,0,0,218,0,216,0,115,0,0,0,5,0,136,0,0,0,82,0,213,0,102,0,0,0,165,0,195,0,26,0,70,0,38,0,244,0,80,0,0,0,0,0,123,0,170,0,0,0,198,0,88,0,183,0,0,0,155,0,164,0,170,0,0,0,208,0,201,0,129,0,0,0,128,0,72,0,141,0,72,0,246,0,210,0,241,0,0,0,0,0,0,0,51,0,0,0,0,0,44,0,163,0,16,0,185,0,162,0,198,0,148,0,115,0,208,0,18,0,0,0,233,0,240,0,2,0,69,0,0,0,199,0,5,0,0,0,110,0,120,0,43,0,140,0,45,0,0,0,75,0,200,0,208,0,0,0,196,0,163,0,159,0,0,0,0,0,0,0,190,0,237,0,22,0,0,0,29,0,0,0,219,0,64,0,154,0,171,0,0,0,0,0,182,0,214,0,163,0,0,0,19,0,119,0,183,0,248,0,98,0,200,0,87,0,19,0,167,0,58,0,0,0,157,0,15,0,7,0,0,0,112,0,0,0,0,0,176,0,12,0,88,0,82,0,92,0,149,0,120,0);
signal scenario_full  : scenario_type := (0,0,166,31,244,31,10,31,208,31,208,30,237,31,83,31,57,31,102,31,201,31,242,31,242,30,247,31,247,30,143,31,81,31,201,31,201,30,156,31,156,30,50,31,68,31,97,31,92,31,92,30,92,29,44,31,104,31,188,31,248,31,248,30,123,31,83,31,190,31,209,31,73,31,73,30,58,31,58,30,199,31,199,31,199,30,118,31,6,31,6,30,6,29,8,31,109,31,136,31,93,31,212,31,179,31,88,31,58,31,28,31,20,31,239,31,252,31,104,31,200,31,116,31,132,31,144,31,36,31,162,31,78,31,181,31,247,31,34,31,101,31,147,31,123,31,7,31,7,30,78,31,236,31,34,31,89,31,157,31,47,31,122,31,118,31,29,31,15,31,140,31,121,31,6,31,6,30,95,31,227,31,164,31,240,31,71,31,195,31,174,31,188,31,233,31,132,31,132,30,53,31,153,31,153,30,126,31,126,30,185,31,185,30,185,29,79,31,93,31,108,31,108,30,163,31,180,31,180,30,227,31,230,31,249,31,19,31,19,30,43,31,71,31,5,31,79,31,192,31,104,31,59,31,32,31,138,31,138,30,1,31,102,31,230,31,133,31,68,31,68,30,89,31,160,31,116,31,42,31,40,31,17,31,25,31,198,31,236,31,31,31,84,31,169,31,105,31,150,31,190,31,200,31,200,30,53,31,223,31,223,30,156,31,184,31,63,31,100,31,237,31,237,30,60,31,45,31,18,31,18,30,26,31,241,31,125,31,125,30,122,31,99,31,244,31,244,30,15,31,6,31,56,31,59,31,135,31,18,31,173,31,170,31,85,31,203,31,249,31,76,31,119,31,154,31,49,31,49,30,203,31,225,31,116,31,169,31,169,30,115,31,115,30,100,31,106,31,229,31,46,31,46,30,10,31,10,30,9,31,64,31,28,31,129,31,82,31,181,31,106,31,62,31,80,31,110,31,22,31,36,31,19,31,77,31,77,30,181,31,191,31,118,31,19,31,75,31,75,30,249,31,56,31,68,31,165,31,10,31,10,30,225,31,235,31,108,31,98,31,116,31,187,31,187,30,192,31,192,30,209,31,51,31,152,31,49,31,114,31,104,31,246,31,68,31,68,30,221,31,221,30,64,31,26,31,210,31,2,31,214,31,163,31,163,30,189,31,198,31,208,31,21,31,7,31,216,31,214,31,47,31,15,31,239,31,4,31,4,30,4,29,24,31,24,30,7,31,176,31,176,30,28,31,37,31,75,31,175,31,99,31,85,31,85,30,155,31,156,31,87,31,87,30,125,31,27,31,189,31,235,31,88,31,88,30,132,31,139,31,136,31,165,31,75,31,75,30,75,29,75,28,75,27,75,26,75,25,224,31,250,31,199,31,163,31,6,31,6,30,86,31,86,30,195,31,201,31,28,31,175,31,169,31,169,30,135,31,126,31,227,31,69,31,69,30,10,31,10,30,58,31,58,30,58,29,100,31,199,31,30,31,108,31,241,31,134,31,103,31,238,31,144,31,238,31,238,30,68,31,81,31,81,30,247,31,43,31,201,31,243,31,67,31,147,31,117,31,92,31,107,31,107,30,11,31,151,31,227,31,226,31,22,31,172,31,167,31,190,31,190,30,128,31,14,31,137,31,47,31,47,30,147,31,147,30,129,31,185,31,245,31,245,30,77,31,200,31,147,31,23,31,23,30,65,31,65,30,65,29,233,31,35,31,208,31,192,31,40,31,91,31,112,31,112,30,119,31,149,31,149,30,1,31,113,31,160,31,113,31,105,31,31,31,6,31,8,31,246,31,81,31,165,31,215,31,196,31,254,31,232,31,105,31,94,31,232,31,145,31,145,30,214,31,23,31,224,31,140,31,161,31,193,31,247,31,72,31,211,31,82,31,65,31,246,31,154,31,105,31,105,30,128,31,124,31,38,31,76,31,251,31,102,31,228,31,117,31,26,31,134,31,134,30,254,31,181,31,249,31,124,31,238,31,143,31,227,31,141,31,141,30,141,29,255,31,255,30,9,31,49,31,49,30,30,31,30,30,80,31,126,31,111,31,190,31,230,31,171,31,196,31,148,31,116,31,173,31,36,31,36,30,73,31,147,31,5,31,77,31,77,30,111,31,111,30,47,31,151,31,43,31,159,31,237,31,57,31,187,31,237,31,117,31,152,31,216,31,242,31,242,30,227,31,227,30,218,31,216,31,115,31,115,30,5,31,136,31,136,30,82,31,213,31,102,31,102,30,165,31,195,31,26,31,70,31,38,31,244,31,80,31,80,30,80,29,123,31,170,31,170,30,198,31,88,31,183,31,183,30,155,31,164,31,170,31,170,30,208,31,201,31,129,31,129,30,128,31,72,31,141,31,72,31,246,31,210,31,241,31,241,30,241,29,241,28,51,31,51,30,51,29,44,31,163,31,16,31,185,31,162,31,198,31,148,31,115,31,208,31,18,31,18,30,233,31,240,31,2,31,69,31,69,30,199,31,5,31,5,30,110,31,120,31,43,31,140,31,45,31,45,30,75,31,200,31,208,31,208,30,196,31,163,31,159,31,159,30,159,29,159,28,190,31,237,31,22,31,22,30,29,31,29,30,219,31,64,31,154,31,171,31,171,30,171,29,182,31,214,31,163,31,163,30,19,31,119,31,183,31,248,31,98,31,200,31,87,31,19,31,167,31,58,31,58,30,157,31,15,31,7,31,7,30,112,31,112,30,112,29,176,31,12,31,88,31,82,31,92,31,149,31,120,31);

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

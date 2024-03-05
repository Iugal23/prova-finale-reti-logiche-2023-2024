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

constant SCENARIO_LENGTH : integer := 604;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,91,0,168,0,0,0,216,0,226,0,222,0,252,0,23,0,92,0,0,0,5,0,62,0,149,0,151,0,37,0,147,0,66,0,0,0,0,0,65,0,0,0,61,0,175,0,24,0,75,0,219,0,34,0,77,0,230,0,116,0,194,0,150,0,0,0,0,0,148,0,118,0,85,0,132,0,207,0,18,0,214,0,228,0,150,0,57,0,60,0,114,0,0,0,69,0,0,0,94,0,13,0,89,0,124,0,0,0,192,0,60,0,0,0,125,0,254,0,226,0,0,0,246,0,57,0,242,0,0,0,0,0,8,0,219,0,189,0,48,0,106,0,161,0,0,0,0,0,109,0,0,0,174,0,233,0,180,0,3,0,0,0,124,0,16,0,191,0,23,0,40,0,93,0,45,0,227,0,91,0,0,0,0,0,237,0,170,0,165,0,197,0,239,0,172,0,159,0,0,0,143,0,137,0,187,0,101,0,0,0,231,0,20,0,23,0,102,0,21,0,221,0,128,0,214,0,34,0,29,0,230,0,182,0,191,0,221,0,42,0,242,0,152,0,11,0,0,0,91,0,131,0,154,0,251,0,0,0,90,0,229,0,11,0,7,0,58,0,145,0,71,0,31,0,29,0,94,0,15,0,63,0,209,0,5,0,0,0,127,0,209,0,0,0,173,0,8,0,0,0,240,0,83,0,249,0,0,0,240,0,131,0,0,0,183,0,90,0,0,0,4,0,167,0,0,0,13,0,27,0,122,0,11,0,111,0,237,0,61,0,169,0,249,0,58,0,0,0,0,0,101,0,188,0,109,0,38,0,241,0,0,0,61,0,91,0,34,0,52,0,89,0,26,0,136,0,0,0,0,0,60,0,58,0,3,0,241,0,80,0,94,0,245,0,0,0,0,0,175,0,0,0,207,0,0,0,186,0,84,0,149,0,83,0,28,0,19,0,249,0,20,0,50,0,231,0,120,0,254,0,17,0,80,0,195,0,0,0,0,0,199,0,154,0,163,0,135,0,190,0,8,0,90,0,226,0,18,0,101,0,0,0,70,0,0,0,78,0,115,0,38,0,15,0,176,0,87,0,90,0,228,0,48,0,39,0,248,0,161,0,7,0,155,0,125,0,0,0,158,0,30,0,88,0,67,0,133,0,188,0,0,0,95,0,0,0,0,0,58,0,107,0,86,0,200,0,144,0,206,0,97,0,0,0,74,0,0,0,147,0,0,0,210,0,0,0,0,0,132,0,127,0,133,0,85,0,70,0,147,0,13,0,0,0,159,0,36,0,141,0,43,0,45,0,108,0,196,0,222,0,48,0,8,0,202,0,244,0,31,0,235,0,60,0,126,0,203,0,0,0,0,0,183,0,0,0,127,0,178,0,0,0,245,0,49,0,63,0,45,0,9,0,4,0,154,0,224,0,0,0,198,0,230,0,216,0,101,0,0,0,112,0,5,0,214,0,47,0,0,0,12,0,60,0,159,0,4,0,82,0,111,0,0,0,240,0,135,0,55,0,47,0,0,0,203,0,102,0,0,0,4,0,35,0,198,0,201,0,248,0,155,0,0,0,226,0,45,0,245,0,149,0,137,0,85,0,0,0,203,0,186,0,0,0,216,0,63,0,0,0,213,0,253,0,156,0,0,0,60,0,150,0,0,0,27,0,221,0,189,0,0,0,31,0,255,0,116,0,79,0,106,0,171,0,0,0,155,0,178,0,224,0,61,0,69,0,54,0,84,0,0,0,0,0,93,0,100,0,0,0,198,0,0,0,0,0,218,0,186,0,0,0,200,0,90,0,0,0,0,0,42,0,0,0,127,0,211,0,172,0,180,0,95,0,220,0,0,0,56,0,69,0,56,0,0,0,198,0,33,0,206,0,145,0,0,0,49,0,35,0,18,0,29,0,149,0,0,0,193,0,0,0,224,0,114,0,217,0,0,0,76,0,24,0,5,0,233,0,0,0,119,0,5,0,146,0,249,0,190,0,187,0,168,0,242,0,0,0,0,0,184,0,0,0,75,0,103,0,61,0,91,0,84,0,1,0,69,0,95,0,212,0,113,0,170,0,84,0,143,0,132,0,132,0,254,0,98,0,169,0,51,0,11,0,146,0,0,0,0,0,193,0,237,0,133,0,130,0,0,0,94,0,224,0,209,0,164,0,124,0,234,0,138,0,138,0,189,0,0,0,232,0,25,0,0,0,40,0,9,0,182,0,0,0,190,0,239,0,105,0,102,0,117,0,112,0,80,0,118,0,0,0,211,0,195,0,178,0,204,0,107,0,88,0,87,0,109,0,146,0,45,0,152,0,157,0,54,0,202,0,253,0,31,0,0,0,177,0,6,0,126,0,233,0,0,0,56,0,28,0,0,0,240,0,217,0,139,0,137,0,90,0,106,0,0,0,147,0,119,0,232,0,0,0,213,0,0,0,142,0,155,0,195,0,9,0,0,0,70,0,174,0,0,0,66,0,112,0,167,0,0,0,207,0,0,0,24,0,82,0,85,0,66,0,119,0,172,0,236,0,106,0,212,0,205,0,0,0,0,0,10,0,60,0,98,0,69,0,60,0,204,0,75,0,0,0,132,0,0,0,125,0,30,0,40,0,78,0,179,0,8,0,232,0,0,0,78,0,0,0,0,0,28,0,117,0,78,0,0,0,0,0,0,0,237,0,36,0,122,0,109,0,92,0,249,0,31,0,0,0,97,0,188,0,221,0);
signal scenario_full  : scenario_type := (0,0,91,31,168,31,168,30,216,31,226,31,222,31,252,31,23,31,92,31,92,30,5,31,62,31,149,31,151,31,37,31,147,31,66,31,66,30,66,29,65,31,65,30,61,31,175,31,24,31,75,31,219,31,34,31,77,31,230,31,116,31,194,31,150,31,150,30,150,29,148,31,118,31,85,31,132,31,207,31,18,31,214,31,228,31,150,31,57,31,60,31,114,31,114,30,69,31,69,30,94,31,13,31,89,31,124,31,124,30,192,31,60,31,60,30,125,31,254,31,226,31,226,30,246,31,57,31,242,31,242,30,242,29,8,31,219,31,189,31,48,31,106,31,161,31,161,30,161,29,109,31,109,30,174,31,233,31,180,31,3,31,3,30,124,31,16,31,191,31,23,31,40,31,93,31,45,31,227,31,91,31,91,30,91,29,237,31,170,31,165,31,197,31,239,31,172,31,159,31,159,30,143,31,137,31,187,31,101,31,101,30,231,31,20,31,23,31,102,31,21,31,221,31,128,31,214,31,34,31,29,31,230,31,182,31,191,31,221,31,42,31,242,31,152,31,11,31,11,30,91,31,131,31,154,31,251,31,251,30,90,31,229,31,11,31,7,31,58,31,145,31,71,31,31,31,29,31,94,31,15,31,63,31,209,31,5,31,5,30,127,31,209,31,209,30,173,31,8,31,8,30,240,31,83,31,249,31,249,30,240,31,131,31,131,30,183,31,90,31,90,30,4,31,167,31,167,30,13,31,27,31,122,31,11,31,111,31,237,31,61,31,169,31,249,31,58,31,58,30,58,29,101,31,188,31,109,31,38,31,241,31,241,30,61,31,91,31,34,31,52,31,89,31,26,31,136,31,136,30,136,29,60,31,58,31,3,31,241,31,80,31,94,31,245,31,245,30,245,29,175,31,175,30,207,31,207,30,186,31,84,31,149,31,83,31,28,31,19,31,249,31,20,31,50,31,231,31,120,31,254,31,17,31,80,31,195,31,195,30,195,29,199,31,154,31,163,31,135,31,190,31,8,31,90,31,226,31,18,31,101,31,101,30,70,31,70,30,78,31,115,31,38,31,15,31,176,31,87,31,90,31,228,31,48,31,39,31,248,31,161,31,7,31,155,31,125,31,125,30,158,31,30,31,88,31,67,31,133,31,188,31,188,30,95,31,95,30,95,29,58,31,107,31,86,31,200,31,144,31,206,31,97,31,97,30,74,31,74,30,147,31,147,30,210,31,210,30,210,29,132,31,127,31,133,31,85,31,70,31,147,31,13,31,13,30,159,31,36,31,141,31,43,31,45,31,108,31,196,31,222,31,48,31,8,31,202,31,244,31,31,31,235,31,60,31,126,31,203,31,203,30,203,29,183,31,183,30,127,31,178,31,178,30,245,31,49,31,63,31,45,31,9,31,4,31,154,31,224,31,224,30,198,31,230,31,216,31,101,31,101,30,112,31,5,31,214,31,47,31,47,30,12,31,60,31,159,31,4,31,82,31,111,31,111,30,240,31,135,31,55,31,47,31,47,30,203,31,102,31,102,30,4,31,35,31,198,31,201,31,248,31,155,31,155,30,226,31,45,31,245,31,149,31,137,31,85,31,85,30,203,31,186,31,186,30,216,31,63,31,63,30,213,31,253,31,156,31,156,30,60,31,150,31,150,30,27,31,221,31,189,31,189,30,31,31,255,31,116,31,79,31,106,31,171,31,171,30,155,31,178,31,224,31,61,31,69,31,54,31,84,31,84,30,84,29,93,31,100,31,100,30,198,31,198,30,198,29,218,31,186,31,186,30,200,31,90,31,90,30,90,29,42,31,42,30,127,31,211,31,172,31,180,31,95,31,220,31,220,30,56,31,69,31,56,31,56,30,198,31,33,31,206,31,145,31,145,30,49,31,35,31,18,31,29,31,149,31,149,30,193,31,193,30,224,31,114,31,217,31,217,30,76,31,24,31,5,31,233,31,233,30,119,31,5,31,146,31,249,31,190,31,187,31,168,31,242,31,242,30,242,29,184,31,184,30,75,31,103,31,61,31,91,31,84,31,1,31,69,31,95,31,212,31,113,31,170,31,84,31,143,31,132,31,132,31,254,31,98,31,169,31,51,31,11,31,146,31,146,30,146,29,193,31,237,31,133,31,130,31,130,30,94,31,224,31,209,31,164,31,124,31,234,31,138,31,138,31,189,31,189,30,232,31,25,31,25,30,40,31,9,31,182,31,182,30,190,31,239,31,105,31,102,31,117,31,112,31,80,31,118,31,118,30,211,31,195,31,178,31,204,31,107,31,88,31,87,31,109,31,146,31,45,31,152,31,157,31,54,31,202,31,253,31,31,31,31,30,177,31,6,31,126,31,233,31,233,30,56,31,28,31,28,30,240,31,217,31,139,31,137,31,90,31,106,31,106,30,147,31,119,31,232,31,232,30,213,31,213,30,142,31,155,31,195,31,9,31,9,30,70,31,174,31,174,30,66,31,112,31,167,31,167,30,207,31,207,30,24,31,82,31,85,31,66,31,119,31,172,31,236,31,106,31,212,31,205,31,205,30,205,29,10,31,60,31,98,31,69,31,60,31,204,31,75,31,75,30,132,31,132,30,125,31,30,31,40,31,78,31,179,31,8,31,232,31,232,30,78,31,78,30,78,29,28,31,117,31,78,31,78,30,78,29,78,28,237,31,36,31,122,31,109,31,92,31,249,31,31,31,31,30,97,31,188,31,221,31);

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

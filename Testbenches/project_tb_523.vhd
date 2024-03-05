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

constant SCENARIO_LENGTH : integer := 323;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (237,0,145,0,5,0,0,0,0,0,0,0,251,0,178,0,0,0,0,0,145,0,6,0,18,0,0,0,247,0,224,0,240,0,133,0,160,0,25,0,227,0,195,0,15,0,0,0,84,0,0,0,61,0,29,0,188,0,0,0,82,0,94,0,115,0,0,0,75,0,33,0,186,0,87,0,77,0,28,0,225,0,242,0,104,0,25,0,0,0,93,0,0,0,182,0,206,0,58,0,46,0,0,0,230,0,0,0,61,0,0,0,0,0,156,0,37,0,0,0,248,0,100,0,89,0,16,0,60,0,191,0,0,0,206,0,155,0,0,0,142,0,0,0,252,0,122,0,0,0,77,0,226,0,0,0,236,0,153,0,149,0,130,0,108,0,1,0,72,0,253,0,0,0,194,0,115,0,36,0,15,0,234,0,173,0,220,0,103,0,0,0,171,0,0,0,216,0,143,0,61,0,129,0,93,0,204,0,139,0,0,0,82,0,210,0,177,0,26,0,221,0,0,0,89,0,1,0,0,0,30,0,70,0,2,0,0,0,0,0,7,0,147,0,0,0,0,0,253,0,0,0,45,0,237,0,0,0,29,0,181,0,192,0,107,0,226,0,202,0,90,0,64,0,222,0,9,0,113,0,57,0,157,0,0,0,42,0,188,0,192,0,0,0,122,0,230,0,32,0,4,0,244,0,100,0,198,0,161,0,166,0,225,0,77,0,0,0,138,0,17,0,148,0,214,0,63,0,80,0,170,0,45,0,195,0,69,0,92,0,83,0,44,0,34,0,174,0,113,0,108,0,36,0,244,0,65,0,53,0,106,0,103,0,159,0,113,0,118,0,190,0,38,0,165,0,26,0,5,0,209,0,101,0,45,0,0,0,4,0,28,0,236,0,148,0,251,0,69,0,143,0,249,0,147,0,176,0,168,0,91,0,108,0,142,0,58,0,6,0,180,0,222,0,25,0,131,0,0,0,19,0,173,0,93,0,216,0,0,0,138,0,95,0,91,0,155,0,23,0,152,0,9,0,22,0,36,0,0,0,140,0,74,0,138,0,78,0,0,0,127,0,18,0,39,0,177,0,225,0,145,0,135,0,109,0,249,0,12,0,0,0,140,0,120,0,129,0,245,0,39,0,0,0,187,0,156,0,185,0,195,0,140,0,6,0,0,0,183,0,0,0,177,0,250,0,75,0,8,0,0,0,57,0,194,0,102,0,145,0,3,0,46,0,174,0,0,0,0,0,214,0,40,0,210,0,20,0,7,0,156,0,0,0,252,0,197,0,47,0,0,0,181,0,0,0,227,0,0,0,100,0,246,0,60,0,0,0,23,0,75,0,177,0,229,0,63,0,0,0,134,0,0,0,76,0,69,0,238,0,222,0,0,0,0,0,65,0,91,0,165,0,0,0,66,0,230,0,89,0,95,0,222,0,0,0,118,0,0,0,0,0,222,0,213,0);
signal scenario_full  : scenario_type := (237,31,145,31,5,31,5,30,5,29,5,28,251,31,178,31,178,30,178,29,145,31,6,31,18,31,18,30,247,31,224,31,240,31,133,31,160,31,25,31,227,31,195,31,15,31,15,30,84,31,84,30,61,31,29,31,188,31,188,30,82,31,94,31,115,31,115,30,75,31,33,31,186,31,87,31,77,31,28,31,225,31,242,31,104,31,25,31,25,30,93,31,93,30,182,31,206,31,58,31,46,31,46,30,230,31,230,30,61,31,61,30,61,29,156,31,37,31,37,30,248,31,100,31,89,31,16,31,60,31,191,31,191,30,206,31,155,31,155,30,142,31,142,30,252,31,122,31,122,30,77,31,226,31,226,30,236,31,153,31,149,31,130,31,108,31,1,31,72,31,253,31,253,30,194,31,115,31,36,31,15,31,234,31,173,31,220,31,103,31,103,30,171,31,171,30,216,31,143,31,61,31,129,31,93,31,204,31,139,31,139,30,82,31,210,31,177,31,26,31,221,31,221,30,89,31,1,31,1,30,30,31,70,31,2,31,2,30,2,29,7,31,147,31,147,30,147,29,253,31,253,30,45,31,237,31,237,30,29,31,181,31,192,31,107,31,226,31,202,31,90,31,64,31,222,31,9,31,113,31,57,31,157,31,157,30,42,31,188,31,192,31,192,30,122,31,230,31,32,31,4,31,244,31,100,31,198,31,161,31,166,31,225,31,77,31,77,30,138,31,17,31,148,31,214,31,63,31,80,31,170,31,45,31,195,31,69,31,92,31,83,31,44,31,34,31,174,31,113,31,108,31,36,31,244,31,65,31,53,31,106,31,103,31,159,31,113,31,118,31,190,31,38,31,165,31,26,31,5,31,209,31,101,31,45,31,45,30,4,31,28,31,236,31,148,31,251,31,69,31,143,31,249,31,147,31,176,31,168,31,91,31,108,31,142,31,58,31,6,31,180,31,222,31,25,31,131,31,131,30,19,31,173,31,93,31,216,31,216,30,138,31,95,31,91,31,155,31,23,31,152,31,9,31,22,31,36,31,36,30,140,31,74,31,138,31,78,31,78,30,127,31,18,31,39,31,177,31,225,31,145,31,135,31,109,31,249,31,12,31,12,30,140,31,120,31,129,31,245,31,39,31,39,30,187,31,156,31,185,31,195,31,140,31,6,31,6,30,183,31,183,30,177,31,250,31,75,31,8,31,8,30,57,31,194,31,102,31,145,31,3,31,46,31,174,31,174,30,174,29,214,31,40,31,210,31,20,31,7,31,156,31,156,30,252,31,197,31,47,31,47,30,181,31,181,30,227,31,227,30,100,31,246,31,60,31,60,30,23,31,75,31,177,31,229,31,63,31,63,30,134,31,134,30,76,31,69,31,238,31,222,31,222,30,222,29,65,31,91,31,165,31,165,30,66,31,230,31,89,31,95,31,222,31,222,30,118,31,118,30,118,29,222,31,213,31);

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

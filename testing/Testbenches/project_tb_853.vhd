-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_853 is
end project_tb_853;

architecture project_tb_arch_853 of project_tb_853 is
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

constant SCENARIO_LENGTH : integer := 494;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (15,0,65,0,182,0,172,0,15,0,0,0,188,0,160,0,132,0,121,0,75,0,3,0,0,0,121,0,0,0,238,0,247,0,0,0,97,0,193,0,166,0,129,0,0,0,91,0,72,0,0,0,111,0,166,0,132,0,0,0,0,0,105,0,49,0,226,0,108,0,105,0,0,0,93,0,119,0,107,0,251,0,0,0,134,0,130,0,107,0,234,0,0,0,33,0,0,0,80,0,150,0,225,0,232,0,46,0,0,0,0,0,252,0,0,0,106,0,170,0,0,0,181,0,34,0,18,0,181,0,0,0,5,0,217,0,42,0,0,0,95,0,57,0,51,0,0,0,127,0,5,0,198,0,134,0,29,0,180,0,103,0,96,0,133,0,74,0,211,0,235,0,112,0,0,0,136,0,154,0,114,0,0,0,7,0,104,0,245,0,196,0,0,0,144,0,249,0,213,0,75,0,63,0,191,0,226,0,15,0,0,0,135,0,200,0,224,0,0,0,72,0,33,0,203,0,239,0,186,0,0,0,0,0,48,0,158,0,209,0,99,0,247,0,147,0,125,0,241,0,3,0,114,0,147,0,61,0,166,0,55,0,196,0,94,0,245,0,168,0,199,0,213,0,199,0,238,0,141,0,0,0,194,0,5,0,127,0,105,0,29,0,195,0,0,0,2,0,0,0,15,0,52,0,157,0,140,0,0,0,0,0,211,0,34,0,68,0,0,0,152,0,29,0,155,0,205,0,4,0,1,0,44,0,44,0,116,0,29,0,227,0,0,0,190,0,0,0,139,0,10,0,8,0,87,0,105,0,6,0,241,0,210,0,174,0,235,0,19,0,96,0,22,0,0,0,72,0,3,0,0,0,201,0,177,0,0,0,242,0,216,0,213,0,232,0,227,0,0,0,13,0,221,0,0,0,58,0,0,0,139,0,153,0,68,0,43,0,62,0,21,0,253,0,0,0,145,0,0,0,201,0,89,0,0,0,75,0,105,0,233,0,228,0,115,0,149,0,0,0,11,0,197,0,207,0,82,0,51,0,0,0,50,0,194,0,241,0,120,0,0,0,0,0,91,0,252,0,5,0,196,0,136,0,195,0,17,0,0,0,163,0,64,0,88,0,191,0,17,0,65,0,87,0,0,0,11,0,186,0,205,0,43,0,159,0,220,0,11,0,57,0,196,0,41,0,157,0,84,0,239,0,254,0,73,0,52,0,248,0,87,0,0,0,98,0,160,0,98,0,57,0,148,0,252,0,21,0,113,0,241,0,240,0,214,0,168,0,23,0,148,0,160,0,113,0,43,0,204,0,72,0,104,0,201,0,43,0,198,0,233,0,234,0,235,0,0,0,49,0,0,0,10,0,194,0,149,0,180,0,0,0,170,0,40,0,54,0,224,0,13,0,183,0,0,0,136,0,0,0,32,0,101,0,0,0,227,0,121,0,17,0,43,0,224,0,9,0,168,0,0,0,0,0,179,0,149,0,52,0,110,0,0,0,18,0,150,0,77,0,121,0,0,0,178,0,3,0,165,0,224,0,182,0,188,0,0,0,113,0,235,0,58,0,50,0,0,0,15,0,26,0,27,0,20,0,0,0,0,0,177,0,4,0,97,0,73,0,92,0,195,0,249,0,161,0,248,0,193,0,87,0,146,0,86,0,247,0,206,0,124,0,144,0,0,0,181,0,211,0,0,0,12,0,0,0,141,0,184,0,237,0,248,0,215,0,0,0,89,0,77,0,0,0,236,0,0,0,0,0,188,0,0,0,0,0,0,0,160,0,84,0,108,0,39,0,205,0,158,0,40,0,207,0,155,0,180,0,227,0,152,0,0,0,0,0,182,0,0,0,0,0,18,0,83,0,246,0,63,0,115,0,161,0,159,0,0,0,206,0,0,0,0,0,6,0,109,0,56,0,4,0,65,0,213,0,246,0,118,0,25,0,210,0,145,0,198,0,103,0,16,0,167,0,170,0,183,0,244,0,206,0,0,0,157,0,0,0,0,0,173,0,20,0,0,0,0,0,230,0,149,0,0,0,108,0,57,0,5,0,20,0,215,0,58,0,0,0,102,0,129,0,228,0,0,0,44,0,4,0,0,0,175,0,162,0,201,0,102,0,241,0,0,0,146,0,238,0,72,0,182,0,0,0,66,0,203,0,213,0,143,0,42,0,238,0,0,0,225,0,161,0,177,0,150,0,27,0,120,0,131,0,20,0,0,0,25,0);
signal scenario_full  : scenario_type := (15,31,65,31,182,31,172,31,15,31,15,30,188,31,160,31,132,31,121,31,75,31,3,31,3,30,121,31,121,30,238,31,247,31,247,30,97,31,193,31,166,31,129,31,129,30,91,31,72,31,72,30,111,31,166,31,132,31,132,30,132,29,105,31,49,31,226,31,108,31,105,31,105,30,93,31,119,31,107,31,251,31,251,30,134,31,130,31,107,31,234,31,234,30,33,31,33,30,80,31,150,31,225,31,232,31,46,31,46,30,46,29,252,31,252,30,106,31,170,31,170,30,181,31,34,31,18,31,181,31,181,30,5,31,217,31,42,31,42,30,95,31,57,31,51,31,51,30,127,31,5,31,198,31,134,31,29,31,180,31,103,31,96,31,133,31,74,31,211,31,235,31,112,31,112,30,136,31,154,31,114,31,114,30,7,31,104,31,245,31,196,31,196,30,144,31,249,31,213,31,75,31,63,31,191,31,226,31,15,31,15,30,135,31,200,31,224,31,224,30,72,31,33,31,203,31,239,31,186,31,186,30,186,29,48,31,158,31,209,31,99,31,247,31,147,31,125,31,241,31,3,31,114,31,147,31,61,31,166,31,55,31,196,31,94,31,245,31,168,31,199,31,213,31,199,31,238,31,141,31,141,30,194,31,5,31,127,31,105,31,29,31,195,31,195,30,2,31,2,30,15,31,52,31,157,31,140,31,140,30,140,29,211,31,34,31,68,31,68,30,152,31,29,31,155,31,205,31,4,31,1,31,44,31,44,31,116,31,29,31,227,31,227,30,190,31,190,30,139,31,10,31,8,31,87,31,105,31,6,31,241,31,210,31,174,31,235,31,19,31,96,31,22,31,22,30,72,31,3,31,3,30,201,31,177,31,177,30,242,31,216,31,213,31,232,31,227,31,227,30,13,31,221,31,221,30,58,31,58,30,139,31,153,31,68,31,43,31,62,31,21,31,253,31,253,30,145,31,145,30,201,31,89,31,89,30,75,31,105,31,233,31,228,31,115,31,149,31,149,30,11,31,197,31,207,31,82,31,51,31,51,30,50,31,194,31,241,31,120,31,120,30,120,29,91,31,252,31,5,31,196,31,136,31,195,31,17,31,17,30,163,31,64,31,88,31,191,31,17,31,65,31,87,31,87,30,11,31,186,31,205,31,43,31,159,31,220,31,11,31,57,31,196,31,41,31,157,31,84,31,239,31,254,31,73,31,52,31,248,31,87,31,87,30,98,31,160,31,98,31,57,31,148,31,252,31,21,31,113,31,241,31,240,31,214,31,168,31,23,31,148,31,160,31,113,31,43,31,204,31,72,31,104,31,201,31,43,31,198,31,233,31,234,31,235,31,235,30,49,31,49,30,10,31,194,31,149,31,180,31,180,30,170,31,40,31,54,31,224,31,13,31,183,31,183,30,136,31,136,30,32,31,101,31,101,30,227,31,121,31,17,31,43,31,224,31,9,31,168,31,168,30,168,29,179,31,149,31,52,31,110,31,110,30,18,31,150,31,77,31,121,31,121,30,178,31,3,31,165,31,224,31,182,31,188,31,188,30,113,31,235,31,58,31,50,31,50,30,15,31,26,31,27,31,20,31,20,30,20,29,177,31,4,31,97,31,73,31,92,31,195,31,249,31,161,31,248,31,193,31,87,31,146,31,86,31,247,31,206,31,124,31,144,31,144,30,181,31,211,31,211,30,12,31,12,30,141,31,184,31,237,31,248,31,215,31,215,30,89,31,77,31,77,30,236,31,236,30,236,29,188,31,188,30,188,29,188,28,160,31,84,31,108,31,39,31,205,31,158,31,40,31,207,31,155,31,180,31,227,31,152,31,152,30,152,29,182,31,182,30,182,29,18,31,83,31,246,31,63,31,115,31,161,31,159,31,159,30,206,31,206,30,206,29,6,31,109,31,56,31,4,31,65,31,213,31,246,31,118,31,25,31,210,31,145,31,198,31,103,31,16,31,167,31,170,31,183,31,244,31,206,31,206,30,157,31,157,30,157,29,173,31,20,31,20,30,20,29,230,31,149,31,149,30,108,31,57,31,5,31,20,31,215,31,58,31,58,30,102,31,129,31,228,31,228,30,44,31,4,31,4,30,175,31,162,31,201,31,102,31,241,31,241,30,146,31,238,31,72,31,182,31,182,30,66,31,203,31,213,31,143,31,42,31,238,31,238,30,225,31,161,31,177,31,150,31,27,31,120,31,131,31,20,31,20,30,25,31);

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
